//
//  Games_View_Model.swift
//  PokerNight
//
//  Created by Logan Roche on 3/18/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Games_View_Model: ObservableObject {
    @Published var games = [Game]()
    @Published var game: Game = Game(date: Date(), title: "", total_buy_in: 0, total_buy_out: 0, player_count: 0, host_id: "" , sb_bb: "N/A", is_active: false, users: [:], transactions: [])
    
    private var db = Firestore.firestore()
    
    func Fetch_Data() {
        db.collection("Games").addSnapshotListener { (query_snapshot, error) in
            guard let documents = query_snapshot?.documents else {
                print("No documents")
                return
            }
            self.games =  documents.compactMap { (query_document_snapshot) -> Game? in
                return try? query_document_snapshot.data(as: Game.self)
            }
        }
        print("Games Updated")
    }
    func Start_Game(game: Game, completion: @escaping (String?) -> Void) {
        do {
                let ref = try db.collection("Games").addDocument(from: game)  // Get the DocumentReference
                let gameId = ref.documentID                                  // Extract the document ID
                print("Document added with ID: \(gameId)")
                completion(gameId)
            } catch {
                print("Error adding document: \(error.localizedDescription)")
                completion(nil)
            }    }
    

//    func fetchGame(gameId: String, completion: @escaping (Game?) -> Void) {
//        
//        let gameRef = db.collection("games").document(gameId)
//        
//        gameRef.getDocument { snapshot, error in
//            guard let document = snapshot, document.exists,
//                  let game = try? document.data(as: Game.self) else {
//                print("Failed to fetch game: \(error?.localizedDescription ?? "Unknown error")")
//                completion(nil)
//                return
//            }
//            
//            print("Game ID: \(game.id ?? "No ID")")  // Access the gameId here
//            completion(game)
//        }
//    }


    func Add_or_Update_User_To_Game(gameId: String, user_id: String, user_stats: User_Stats, completion: @escaping (Error?) -> Void) {

        let user_stats: [String: Any] = [
            "buy_in": user_stats.buy_in,
            "buy_out": user_stats.buy_out,
            "net":user_stats.net
        ]

        // Use Firestore's dot notation to add/update the user inside the "users" dictionary
        db.collection("Games").document(gameId).updateData([
            "users.\(user_id)": user_stats
        ]) { error in
            if let error = error {
                print("Failed to add/update user: \(error)")
                completion(error)
            } else {
                print("User added/updated successfully!")
                completion(nil)
            }
        }
    }

    
//    func fetchUserStats(userId: String, completion: @escaping (Double, Double, Double) -> Void) {
//        db.collection("games")
//            .whereField("users.\(userId)", isGreaterThan: [:])  // Filter games with this user
//            .getDocuments { snapshot, error in
//                guard let documents = snapshot?.documents else {
//                    print("No games found or error: \(error?.localizedDescription ?? "Unknown")")
//                    completion(0, 0, 0)
//                    return
//                }
//
//                var totalBuyIn: Double = 0
//                var totalCashOut: Double = 0
//                var totalProfit: Double = 0
//
//                for document in documents {
//                    if let userStats = document.data()["users"] as? [String: [String: Any]],
//                       let stats = userStats[userId] {
//                        
//                        totalBuyIn += stats["totalBuyIn"] as? Double ?? 0
//                        totalCashOut += stats["totalCashOut"] as? Double ?? 0
//                        totalProfit += stats["profit"] as? Double ?? 0
//                    }
//                }
//
//                completion(totalBuyIn, totalCashOut, totalProfit)
//            }
//    }

    
}
