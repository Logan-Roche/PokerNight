import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

class Games_View_Model: ObservableObject {
    @Published var games: [Game] = []
    @Published var game: Game = Game(
        
        date: Date(),
        title: "",
        host_id: "" ,
        sb_bb: "N/A",
        is_active: false,
        chip_error_divided: 0,
        users: [:],
        user_ids: [],
        transactions: []
    )
    
    @Published var totalGames: Int = 0
    @Published var winRate: Double = 0.0
    @Published var averageROI: Double = 0.0
    @Published var totalProfit: Double = 0.0

    
    @ObservedObject private var auth_view_model = Authentication_View_Model()
    
    @Published var currentGameID: String = " "  // Tracks the current game globally

    
    private var db = Firestore.firestore()
    private var gameListener: ListenerRegistration?
    private var userListener: ListenerRegistration?
    
    
    
    func startListeningForCurrentGame(userID: String) {
        // Remove any existing listener to avoid duplicates
        userListener?.remove()

        print("startListeningForCurrentGame")
        userListener = db.collection("Users").document(userID)
            .addSnapshotListener { [weak self] (document, error) in
                guard let doc = document, doc.exists, let data = doc.data() else {
                    //print("No user found or error: \(error?.localizedDescription ?? "Unknown error")")
                    self?.currentGameID = ""  // Reset if no game
                    return
                }

                DispatchQueue.main.async {
                    // Store the current game ID
                    self?.currentGameID = (data["current_game"] as? String)!
                    //print("Current Game ID Updated: \(self?.currentGameID ?? "None")")
                }
            }
    }
    
    func stopListeningForCurrentGame() {
        userListener?.remove()
        userListener = nil
    }
    
    func Fetch_Game(
        gameId: String,
        completion: @escaping (Game?, Error?) -> Void
    ) {
        
        print("Fetch Game Function Called")
        db.collection("Games").document(gameId).getDocument {
            snapshot,
            error in
            if let error = error {
                //print("Error fetching document: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot,
                  snapshot.exists else {
                //print("Document does not exist")
                completion(nil, nil)
                return
            }
            
            // Manually extract the data from the Firestore document
            var usersDict: [String: Game.User_Stats] = [:]
            var transactionsArray: [Transaction] = []
            
            if let data = snapshot.data() {
                // Process users
                if let usersData = data["users"] as? [String: [String: Any]] {
                    for (key, value) in usersData {
                        if let buyIn = value["buy_in"] as? Double,
                           let buyOut = value["buy_out"] as? Double,
                           let net = value["net"] as? Double,
                           let name = value["name"] as? String,
                           let photo_url = value["photo_url"] as? String {
                            usersDict[key] = Game.User_Stats(
                                name: name,
                                buy_in: buyIn,
                                buy_out: buyOut,
                                net: net,
                                photo_url: photo_url
                            )
                        }
                    }
                }

                // Process transactions
                if let transactionsData = data["transactions"] as? [[String: Any]] {
                    for transactionDict in transactionsData {
                        if let userId = transactionDict["userId"] as? String,
                           let name = transactionDict["name"] as? String,
                           let type = transactionDict["type"] as? String,
                           let amount = transactionDict["amount"] as? Double?,
                           let timestamp = transactionDict["timestamp"] as? Timestamp {
                            
                            let transaction = Transaction(
                                id: transactionDict["id"] as? String ?? UUID().uuidString,
                                userId: userId,
                                name: name,
                                type: type,
                                amount: amount,
                                timestamp: timestamp
                                    .dateValue()  // ✅ Convert Firestore Timestamp to Date
                            )
                            
                            transactionsArray.append(transaction)
                        }
                    }
                }
                
                // Map the Firestore data to your `Game` model
                do {
                    let game = Game(
                        id: snapshot.documentID,
                        date: (data["date"] as? Timestamp)?
                            .dateValue() ?? Date(),
                        title: data["title"] as? String ?? "Unknown",
                        host_id: data["host_id"] as? String ?? "",
                        sb_bb: data["sb_bb"] as? String ?? "",
                        is_active: data["is_active"] as? Bool ?? false,
                        chip_error_divided: data["chip_error_divided"] as? Double ?? 0,
                        users: usersDict,
                        transactions: transactionsArray
                    )
                    
                    completion(
                        game,
                        nil
                    ) // Pass the game data back via the completion handler
                } 
            } else {
                completion(
                    nil,
                    NSError(
                        domain: "Fetch_Game",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Data not found in document"]
                    )
                )
            }
        }
    }


    
    func Start_Game(game: Game, completion: @escaping (String?) -> Void) {
        do {
            // Create a copy of `game` with a nil ID
            print("Start game function called")
            var gameToSave = game
            gameToSave.id = nil  // Avoid warning

            let ref = try db.collection("Games").addDocument(
                from: gameToSave
            )  // This avoids setting @DocumentID manually

            let gameId = ref.documentID
            currentGameID = gameId

            DispatchQueue.main.async {
                self.game = gameToSave  // Optional: reset your observable game
                self.game.id = gameId   // Update it manually with Firestore-assigned ID

                completion(gameId)
            }
        } catch {
            completion(nil)
        }
    }
    
    
    func Add_or_Update_User_To_Game(
        gameId: String,
        user_id: String,
        user_stats: User_Stats,
        completion: @escaping (Error?) -> Void
    ) {
        
        let user_stats: [String: Any] = [
            "name": user_stats.name,
            "buy_in": user_stats.buy_in,
            "buy_out": user_stats.buy_out,
            "net":user_stats.net,
            "photo_url": user_stats.photo_url
        ]
        
        
        // Use Firestore's dot notation to add/update the user inside the "users" dictionary
        db.collection("Games").document(gameId).updateData([
            "users.\(user_id)": user_stats,
            "user_ids": FieldValue.arrayUnion([user_id])
        ]) { error in
            if let error = error {
                //print("Failed to add/update user: \(error)")
                completion(error)
            } else {
                //print("User added/updated successfully!")
                completion(nil)
            }
        }
    }
    func Leave_Game(
        userId: String,
        chip_error_divided: Double
    ) {
        db.collection("Users").document(userId).updateData([
            "current_game": ""
        ]) { error in
            if let error = error {
                print("Failed to leave game: \(error)")
            } else {
                print("User left game successfully!")
            }
        }
        
        self.games.append(game)
        
        let localGames = self.games.compactMap { doc in
            self.convertFirestoreGameToLocalGame(doc)
        }
        
        self.saveLocalGames(localGames)
        
        if game.host_id == userId {
            db.collection("Games").document(game.id!).updateData([
                "chip_error_divided": chip_error_divided,
                "is_active": false
            ]) { error in
            }
        }
        game.id = ""
        game.date = Date()
        game.title = ""
        game.host_id = ""
        game.sb_bb = "N/A"
        game.is_active = false
        game.chip_error_divided = 0
        game.users = [:]
        game.user_ids = []
        game.transactions = []
        
        currentGameID = " "
    
    }
    
    func startListening(gameId: String) {
        // Remove any existing listener to avoid duplicates
        gameListener?.remove()
        print("Listening to Game Function Called")
        
        gameListener = db.collection("Games").document(gameId)
            .addSnapshotListener { [weak self] (document, error) in
                guard let doc = document, doc.exists, let data = doc.data() else {
                    print(
                        "No game found or error: \(error?.localizedDescription ?? "Unknown error")"
                    )
                    return
                }
                
                // Extract and map `users` properly
                var usersDict: [String: Game.User_Stats] = [:]
                
                if let usersData = data["users"] as? [String: [String: Any]] {
                    for (key, value) in usersData {
                        if let buyIn = value["buy_in"] as? Double,
                           let buyOut = value["buy_out"] as? Double,
                           let net = value["net"] as? Double,
                           let name = value["name"] as? String,
                           let photo_url = value["photo_url"] as? String{
                            usersDict[key] = Game.User_Stats(
                                name: name,
                                buy_in: buyIn,
                                buy_out: buyOut,
                                net: net,
                                photo_url: photo_url
                                
                            )
                        }
                    }
                }
                
                var transactionsArray: [Transaction] = []

                if let transactionsData = data["transactions"] as? [[String: Any]] {
                    for transactionDict in transactionsData {
                        if let userId = transactionDict["userId"] as? String,
                           let name = transactionDict["name"] as? String,
                           let type = transactionDict["type"] as? String,
                           let amount = transactionDict["amount"] as? Double?,
                           let timestamp = transactionDict["timestamp"] as? Timestamp {
                            
                            let transaction = Transaction(
                                id: transactionDict["id"] as? String ?? UUID().uuidString,
                                userId: userId,
                                name: name,
                                type: type,
                                amount: amount,
                                timestamp: timestamp
                                    .dateValue()  // ✅ Convert Firestore Timestamp to Date
                            )
                            
                            transactionsArray.append(transaction)
                        }
                    }
                }

                // Map the Firestore data to your `Game` model
                DispatchQueue.main.async {
                    self?.game = Game(
                        id: doc.documentID,
                        date: (data["date"] as? Timestamp)?
                            .dateValue() ?? Date(),
                        title: data["title"] as? String ?? "Unknown",
                        host_id: data["host_id"] as? String ?? "",
                        sb_bb: data["sb_bb"] as? String ?? "",
                        is_active: data["is_active"] as? Bool ?? false,
                        chip_error_divided: data["chip_error_divided"] as? Double ?? 0,
                        users: usersDict,
                        transactions: transactionsArray
                    )
                }
            }
    }

    
    // Stop listening to prevent memory leaks
    func stopListening() {
        gameListener?.remove()
        gameListener = nil
        userListener?.remove()
        userListener = nil
    }
    
    func updateUserCurrentGame(
        newGameId: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let user = Auth.auth().currentUser else {
            completion(false)  // Return false if no user is logged in
            return
        }
        
        let userRef = db.collection("Users").document(user.uid)
        
        // Update the current_game field with the new game ID
        currentGameID = newGameId
        userRef.updateData([
            "current_game": newGameId
        ]) { error in
            if let error = error {
                print(
                    "Error updating current_game: \(error.localizedDescription)"
                )
                completion(false)  // Return false if there’s an error
            } else {
                print("User's current_game updated successfully")
                completion(true)  // Return true if the update is successful
            }
        }
    }
    
    
    func Add_Transaction(
        gameId: String,
        user_id: String,
        display_name: String = "",
        type: String,
        amount: Double?,
        completion: @escaping (Error?) -> Void
    ) {
        
        let new_transaction = Transaction(
            id: nil,
            userId: user_id,
            name: display_name == "" ? auth_view_model.display_name : display_name,
            type: type,
            amount: amount,
            timestamp: Date()
        )

        
        // Append the new transaction to the existing array
        db
            .collection("Games")
            .document(gameId)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                
                    var transactions: [Transaction] = []

                    // Decode existing transactions
                    if let data = document.data(),
                       let existingTransactions = data["transactions"] as? [[String: Any]] {
                    
                        // Convert all `FIRTimestamp` to `Date`
                        transactions = existingTransactions.compactMap { dict in
                            guard let userId = dict["userId"] as? String,
                                  let name = dict["name"] as? String,
                                  let type = dict["type"] as? String,
                                  let amount = dict["amount"] as? Double?,
                                  let timestamp = dict["timestamp"] as? Timestamp else {
                                return nil
                            }
                        
                            return Transaction(
                                id: nil,
                                userId: userId,
                                name: name,
                                type: type,
                                amount: amount,
                                timestamp: timestamp
                                    .dateValue()  // Convert to `Date`
                            )
                        }
                    }
                
                    // Append the new transaction
                    transactions.append(new_transaction)

                    // Encode the updated array with `Timestamp`
                    let encodedTransactions = transactions.map { transaction -> [String: Any] in
                        return [
                            "userId": transaction.userId,
                            "name": transaction.name,
                            "type": transaction.type,
                            "amount": transaction.amount ?? 0.0,
                            "timestamp": Timestamp(
                                date: transaction.timestamp
                            )  // Use Firestore Timestamp
                        ]
                    }

                    // Save back to Firestore
                    self.db.collection("Games").document(gameId).updateData([
                        "transactions": encodedTransactions
                    ]) { error in
                        if let error = error {
                            print("Error updating transactions: \(error)")
                        } else {
                            print("Transaction added successfully!")
                        }
                    }
                } else {
                    print("Game not found")
                }
            }
    }
    
    func editGame(game: Game, completion: ((Error?) -> Void)? = nil) {
        let gameRef = db.collection("Games").document(game.id!)

        var usersData: [String: [String: Any]] = [:]
        for (key, userStats) in game.users {
            usersData[key] = [
                "name": userStats.name,
                "buy_in": userStats.buy_in,
                "buy_out": userStats.buy_out,
                "net": userStats.net,
                "photo_url": userStats.photo_url
            ]
        }

        let transactionsData: [[String: Any]] = game.transactions.map { transaction in
            return [
                //"id": transaction.id!,
                "userId": transaction.userId,
                "name": transaction.name,
                "type": transaction.type,
                "amount": transaction.amount as Any,
                "timestamp": Timestamp(date: transaction.timestamp)
            ]
        }

        let data: [String: Any] = [
            "date": Timestamp(date: game.date),
            "title": game.title,
            "host_id": game.host_id,
            "sb_bb": game.sb_bb,
            "is_active": game.is_active,
            "chip_error_divided": game.chip_error_divided,
            "users": usersData,
            "transactions": transactionsData
        ]

        gameRef.setData(data) { error in
            if let error = error {
                print("Error updating game: \(error.localizedDescription)")
            } else {
                print("Game successfully updated.")
            }
            completion?(error)
        }
    }

    
    
    func fetchPastGames(
        for userID: String,
        completion: @escaping ([Game]) -> Void
    ) {
        print("fetch past games function call")
        
        let local_games = self.loadLocalGames()
        let firestoreGames = local_games.compactMap { convertLocalGameToFirestoreGame($0) }
        
        if firestoreGames.count > 0 {
            print("✅ Games are loaded from local storage")
            completion(firestoreGames)
            return
        }
        
        print("📡 No local games found — grabbing from Firebase...")
        
        db.collection("Games")
            .whereField("user_ids", arrayContains: userID)
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    print("❌ Error fetching past games:", error?.localizedDescription ?? "Unknown error")
                    completion([])
                    return
                }
                
                let games: [Game] = documents.compactMap { doc in
                    try? doc.data(as: Game.self)
                }
                
            
                let localGames = games.compactMap { self.convertFirestoreGameToLocalGame($0) }
                
                self.saveLocalGames(localGames)
                
                print("✅ Saved \(localGames.count) games to local storage.")
                
                completion(games)
            }
    }

    
    func fetchAndCalculateUserStats(for userID: String) {
        print("Starting fetchAndCalculateUserStats...")
        
        // 1. First, load games from local storage
        self.fetchPastGames(for: userID) { games in
            DispatchQueue.main.async {
                self.games = games
                
                // 2. Now sync any still-active games
                self.syncActiveGamesWithFirebase(for: userID) {
                    print("✅ Finished syncing active games.")
                    
                    // 3. wait to  calculate stats based on loaded local games
                    self.calculateStats(for: userID, basedOn: games)
                }
                
                
            }
        }
    }

    
    func calculateStats(for userID: String, basedOn games: [Game]) {
        self.totalGames = games.count

        var winCount = 0
        var totalNet: Double = 0.0
        var totalROI: Double = 0.0
        
        for game in games {
            if let userStats = game.users[userID] {
                let buyIn = userStats.buy_in
                let buyOut = userStats.buy_out
                let net = buyOut != 0 ? userStats.net + game.chip_error_divided : userStats.net
                
                if net > 0 {
                    winCount += 1
                }
                
                totalNet += net
                
                if buyIn > 0 {
                    let roi = ((buyOut != 0 ? buyOut + game.chip_error_divided : 0.0) - buyIn) / buyIn
                    totalROI += roi
                }
            }
        }
        
        let roiGamesCount = games.filter { $0.users[userID]?.buy_in ?? 0 > 0 }.count
        self.averageROI = roiGamesCount > 0 ? totalROI / Double(roiGamesCount) : 0.0
        self.winRate = games.count > 0 ? Double(winCount) / Double(games.count) : 0.0
        self.totalProfit = totalNet
        
        print("✅ Finished calculating user stats.")
    }

    
    func syncActiveGamesWithFirebase(for userID: String, completion: @escaping () -> Void) {
        print("🔄 Starting sync for active games...")

        let activeGames = self.games.filter { $0.is_active }
        
        guard !activeGames.isEmpty else {
            print("✅ No active games to sync.")
            completion()
            return
        }
        
        let group = DispatchGroup()
        
        for activeGame in activeGames {
            guard let gameId = activeGame.id else {
                print("⚠️ Active game missing ID, skipping.")
                continue
            }
            
            group.enter()
            
            db.collection("Games").document(gameId).getDocument { (snapshot, error) in
                defer { group.leave() }
                
                guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else {
                    print("⚠️ Game \(gameId) not found on server or error occurred.")
                    return
                }
                
                var usersDict: [String: Game.User_Stats] = [:]
                var transactionsArray: [Transaction] = []
                
                if let usersData = data["users"] as? [String: [String: Any]] {
                    for (key, value) in usersData {
                        if let buyIn = value["buy_in"] as? Double,
                           let buyOut = value["buy_out"] as? Double,
                           let net = value["net"] as? Double,
                           let name = value["name"] as? String,
                           let photo_url = value["photo_url"] as? String {
                            usersDict[key] = Game.User_Stats(
                                name: name,
                                buy_in: buyIn,
                                buy_out: buyOut,
                                net: net,
                                photo_url: photo_url
                            )
                        }
                    }
                }
                
                if let transactionsData = data["transactions"] as? [[String: Any]] {
                    for transactionDict in transactionsData {
                        if let userId = transactionDict["userId"] as? String,
                           let name = transactionDict["name"] as? String,
                           let type = transactionDict["type"] as? String,
                           let amount = transactionDict["amount"] as? Double?,
                           let timestamp = transactionDict["timestamp"] as? Timestamp {
                            
                            let transaction = Transaction(
                                id: transactionDict["id"] as? String ?? UUID().uuidString,
                                userId: userId,
                                name: name,
                                type: type,
                                amount: amount,
                                timestamp: timestamp.dateValue()
                            )
                            
                            transactionsArray.append(transaction)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    if let index = self.games.firstIndex(where: { $0.id == gameId }) {
                        self.games[index] = Game(
                            id: snapshot.documentID,
                            date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                            title: data["title"] as? String ?? "Unknown",
                            host_id: data["host_id"] as? String ?? "",
                            sb_bb: data["sb_bb"] as? String ?? "",
                            is_active: data["is_active"] as? Bool ?? false,
                            chip_error_divided: data["chip_error_divided"] as? Double ?? 0,
                            users: usersDict,
                            user_ids: (data["user_ids"] as? [String]) ?? [],
                            transactions: transactionsArray
                        )
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            print("✅ Finished syncing all active games. Saving to local storage...")
            
            let localGames = self.games.compactMap { self.convertFirestoreGameToLocalGame($0) }
            self.saveLocalGames(localGames)
            
            completion()
        }
    }



    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }


    
    func saveLocalGames(_ localGames: [LocalGame]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(localGames)
            let url = getDocumentsDirectory().appendingPathComponent("past_games.json")
            try data.write(to: url, options: .atomic)
            print("✅ Successfully saved games to local storage.")
        } catch {
            print("❌ Failed to save games locally:", error)
        }
    }
    
    func loadLocalGames() -> [LocalGame] {
        let url = getDocumentsDirectory().appendingPathComponent("past_games.json")
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("📂 No past_games.json found — returning empty list.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let localGames = try decoder.decode([LocalGame].self, from: data)
            print("📦 Found \(localGames.count) local games.")
            return localGames
        } catch {
            print("❌ Failed to load local games:", error)
            return []
        }
    }

    
    func convertFirestoreGameToLocalGame(_ game: Game) -> LocalGame? {
        guard let id = game.id else {
            print("❌ Cannot convert Game to LocalGame: missing ID.")
            return nil
        }
        
        let convertedUsers = game.users.mapValues { userStats in
            LocalGame.User_Stats(
                name: userStats.name,
                buy_in: userStats.buy_in,
                buy_out: userStats.buy_out,
                net: userStats.net,
                photo_url: userStats.photo_url
            )
        }
        
        let convertedTransactions = game.transactions.compactMap { transaction -> LocalGame.LocalTransaction? in
            guard let transactionID = transaction.id else {
                print("⚠️ Skipping transaction with missing ID.")
                return nil
            }
            
            return LocalGame.LocalTransaction(
                id: transactionID,
                userId: transaction.userId,
                name: transaction.name,
                type: transaction.type,
                amount: transaction.amount,
                timestamp: transaction.timestamp
            )
        }
        
        return LocalGame(
            id: id,
            date: game.date,
            title: game.title,
            host_id: game.host_id,
            sb_bb: game.sb_bb,
            is_active: game.is_active,
            chip_error_divided: game.chip_error_divided,
            users: convertedUsers,
            user_ids: game.user_ids,
            transactions: convertedTransactions
        )
    }

    
    func convertLocalGameToFirestoreGame(_ localGame: LocalGame) -> Game {
        let convertedUsers = localGame.users.mapValues { userStats in
            Game.User_Stats(
                name: userStats.name,
                buy_in: userStats.buy_in,
                buy_out: userStats.buy_out,
                net: userStats.net,
                photo_url: userStats.photo_url
            )
        }
        
        let convertedTransactions = localGame.transactions.map { transaction in
            Transaction(
                id: transaction.id,
                userId: transaction.userId,
                name: transaction.name,
                type: transaction.type,
                amount: transaction.amount,
                timestamp: transaction.timestamp
            )
        }
        
        return Game(
            id: localGame.id, // if your Game init allows setting id manually, otherwise nil
            date: localGame.date,
            title: localGame.title,
            host_id: localGame.host_id,
            sb_bb: localGame.sb_bb,
            is_active: localGame.is_active,
            chip_error_divided: localGame.chip_error_divided,
            users: convertedUsers,
            user_ids: localGame.user_ids,
            transactions: convertedTransactions
        )
    }

    
    

    
    
    
}




