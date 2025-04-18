//
//  Games_View_Model.swift
//  PokerNight
//
//  Created by Logan Roche on 3/18/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

class Games_View_Model: ObservableObject {
    @Published var games: [Game] = []
    @Published var game: Game = Game(
        
        date: Date(),
        title: "",
        total_buy_in: 0,
        total_buy_out: 0,
        player_count: 0,
        host_id: "" ,
        sb_bb: "N/A",
        is_active: false,
        users: [:],
        user_ids: [],
        transactions: []
    )
    
    @ObservedObject private var auth_view_model = Authentication_View_Model()
    
    @Published var currentGameID: String = " "  // Tracks the current game globally

    
    private var db = Firestore.firestore()
    private var gameListener: ListenerRegistration?
    private var userListener: ListenerRegistration?
    
    
    
    func startListeningForCurrentGame(userID: String) {
        // Remove any existing listener to avoid duplicates
        userListener?.remove()

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
                        total_buy_in: data["total_buy_in"] as? Double ?? 0.0,
                        total_buy_out: data["total_buy_out"] as? Double ?? 0.0,
                        player_count: data["player_count"] as? Int ?? 0,
                        host_id: data["host_id"] as? String ?? "",
                        sb_bb: data["sb_bb"] as? String ?? "",
                        is_active: data["is_active"] as? Bool ?? false,
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
            var gameToSave = game
            gameToSave.id = nil  // Avoid warning

            let ref = try db.collection("Games").addDocument(from: gameToSave)  // This avoids setting @DocumentID manually

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
        userId: String
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
        game.id = ""
        game.date = Date()
        game.title = ""
        game.total_buy_in = 0
        game.total_buy_out = 0
        game.player_count = 0
        game.host_id = ""
        game.sb_bb = "N/A"
        game.is_active = false
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
                        total_buy_in: data["total_buy_in"] as? Double ?? 0.0,
                        total_buy_out: data["total_buy_out"] as? Double ?? 0.0,
                        player_count: data["player_count"] as? Int ?? 0,
                        host_id: data["host_id"] as? String ?? "",
                        sb_bb: data["sb_bb"] as? String ?? "",
                        is_active: data["is_active"] as? Bool ?? false,
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
            "total_buy_in": game.total_buy_in,
            "total_buy_out": game.total_buy_out,
            "player_count": game.player_count,
            "host_id": game.host_id,
            "sb_bb": game.sb_bb,
            "is_active": game.is_active,
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

    
    
    func fetchPastGames(for userID: String, completion: @escaping ([Game]) -> Void) {
        

        db.collection("Games")
            .whereField("user_ids", arrayContains: userID)
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching past games: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }

                let games: [Game] = documents.compactMap { doc in
                    try? doc.data(as: Game.self)
                }

                completion(games)
            }
    }
    

}

