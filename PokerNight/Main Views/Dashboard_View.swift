//
//  Dashboard_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI
import FirebaseAuth

struct Dashboard_View: View {
    
    @ObservedObject private var view_model = Games_View_Model()
    @ObservedObject private var auth_view_model = Authentication_View_Model()
    
    
    
    var body: some View {
        let temp_game = Game(date: Date(), title: "Roche Poker Club", total_buy_in: 100, total_buy_out: 100, player_count: 3, host_id: auth_view_model.user?.uid ?? "" , sb_bb: "25c/50c", is_active: true, users: [:], transactions: [])
        var game_id = ""
        let newStats = User_Stats(buy_in: 200, buy_out: 300, net: 100)
        VStack {
            Text("Dashboard")
            Text(auth_view_model.user?.displayName ?? "")
            Button("New Game") {
                self.view_model.Start_Game(game: temp_game) { gameId in
                    if let gameId = gameId {
                        print("New game ID: \(gameId)")
                        game_id = gameId
                    } else {
                        print("Failed to add game.")
                    }
                }
            }
            .buttonStyle(.bordered)
            .tint(.green)
            
            Button("Add User") {
                self.view_model.Add_or_Update_User_To_Game(gameId: game_id, user_id: auth_view_model.user?.uid ?? "", user_stats: newStats) { error in
                    if let error = error {
                        print("Failed to add user: \(error.localizedDescription)")
                    } else {
                        print("User added/updated successfully!")
                    }
                }
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.colorScheme)
        .onAppear() {
            //view_model.Fetch_Data()
        }
    }
}

struct Dashboard_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Dashboard_View()
                .preferredColorScheme(.dark)
            Dashboard_View()
        }
    }
}
