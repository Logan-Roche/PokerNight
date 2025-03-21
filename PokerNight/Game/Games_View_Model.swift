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
    private var listener: ListenerRegistration?
    
    
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
    
    func startListening(gameId: String) {
        // Remove any existing listener to avoid duplicates
        listener?.remove()
        
        listener = db.collection("Games").document(gameId)
            .addSnapshotListener { [weak self] (document, error) in
                guard let doc = document, doc.exists, let data = doc.data() else {
                    print("No game found or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Map the Firestore data to your `Game` model
                DispatchQueue.main.async {
                    self?.game = Game(
                        id: doc.documentID,
                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                        title: data["title"] as? String ?? "Unknown",
                        total_buy_in: data["total_buy_in"] as? Double ?? 0.0,
                        total_buy_out: data["total_buy_out"] as? Double ?? 0.0,
                        player_count: data["player_count"] as? Int ?? 0,
                        host_id: data["host_id"] as? String ?? "",
                        sb_bb: data["sb_bb"] as? String ?? "",
                        is_active: data["is_active"] as? Bool ?? false,
                        users: data["users"] as? [String: Game.User_Stats] ?? [:]
                    )
                }
                
                print("Game Updated: \(self?.game.title ?? "Unknown")")
            }
    }
    
    // Stop listening to prevent memory leaks
    func stopListening() {
        listener?.remove()
        listener = nil
    }
    
    func updateUserCurrentGame(newGameId: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)  // Return false if no user is logged in
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(user.uid)
        
        // Update the current_game field with the new game ID
        userRef.updateData([
            "current_game": newGameId
        ]) { error in
            if let error = error {
                print("Error updating current_game: \(error.localizedDescription)")
                completion(false)  // Return false if there’s an error
            } else {
                print("User's current_game updated successfully")
                completion(true)  // Return true if the update is successful
            }
        }
    }

}

