//
//  All_Games_View.swift
//  PokerNight
//
//  Created by Logan Roche on 4/17/25.
//

import SwiftUI

struct All_Games_View: View {
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    @Binding var selected_game: Game
    
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    

    let sampleGames: [Game] = [
        Game(
            id: "G1",
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            title: "ROCHE POKER CLUB",
            total_buy_in: 60,
            total_buy_out: 90,
            player_count: 5,
            host_id: "host1",
            sb_bb: "25¢ / 50¢",
            is_active: false,
            users: [
                "user123": Game.User_Stats(
                    name: "Logan",
                    buy_in: 60,
                    buy_out: 90,
                    net: 30,
                    photo_url: ""
                )
            ],
            user_ids: ["user123"],
            transactions: []
        ),
        Game(
            id: "G2",
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            title: "AVA'S POKER ROOM",
            total_buy_in: 100,
            total_buy_out: 95,
            player_count: 6,
            host_id: "host2",
            sb_bb: "50¢ / $1",
            is_active: false,
            users: [
                "user123": Game.User_Stats(
                    name: "Logan",
                    buy_in: 100,
                    buy_out: 95,
                    net: -5,
                    photo_url: ""
                )
            ],
            user_ids: ["user123"],
            transactions: []
        ),
        Game(
            id: "G3",
            date: Calendar.current
                .date(byAdding: .day, value: -10, to: Date())!,
            title: "FRIDAY NIGHT POKER",
            total_buy_in: 40,
            total_buy_out: 40,
            player_count: 4,
            host_id: "host3",
            sb_bb: "$1 / $2",
            is_active: false,
            users: [
                "user123": Game.User_Stats(
                    name: "Logan",
                    buy_in: 40,
                    buy_out: 40,
                    net: 0,
                    photo_url: ""
                )
            ],
            user_ids: ["user123"],
            transactions: []
        )
    ]

    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(.offBlack)
                            .frame(
                                height: geometry.size.height * 1
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: geometry.size.width * 0.05
                                )
                            )
                            .shadow(
                                color: .black.opacity(0.8),
                                radius: 3,
                                x: 0,
                                y: 3
                            )
                            .offset(
                                y: -geometry.size.height * 0.45
                            )
                        
                        Text("All Games")
                            .foregroundStyle(
                                colorScheme == .light ? .black : .white
                            )
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.08
                                )
                            )
                            .padding(.top, geometry.size.height * 0.01)
                    }
                    .frame(maxHeight: geometry.size.height * 0.05)
                    .padding(.bottom, geometry.size.height * 0.06)

                    ForEach(game_view_model.games.sorted(by: { $0.date > $1.date })) { game in
                        if let userStats = game.users[auth_view_model.user!.uid] {
                            //if let userStats = game.users["user123"] {
                            VStack(
                                alignment: .leading,
                                spacing: geometry.size.height * 0.004
                            ) {
                                Text("Title: ")
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.035
                                        )
                                    )
                                    .foregroundStyle(
                                        Color.gray
                                    )
                                                
                                                
                                Text(game.title)
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.04
                                        )
                                    )
                                    .foregroundStyle(
                                        colorScheme == .light ? .black : .white
                                    )
                                                
                                                    
                                                
                                HStack {
                                    VStack {
                                        Text("Date:              ")
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .foregroundStyle(
                                                Color.gray
                                            )
                                        
                                        Text(
                                            game.date
                                                .formatted(
                                                    date: .abbreviated,
                                                    time: .omitted
                                                )
                                        )
                                        .font(
                                            .custom(
                                                "comfortaa",
                                                size: geometry.size.width * 0.04
                                            )
                                        )
                                        .foregroundStyle(
                                            colorScheme == .light ? .black : .white
                                        )
                                    }
                                    
                                    Spacer()
                                    VStack {
                                        Text("Net:         ")
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .foregroundStyle(
                                                Color.gray
                                            )
                                        
                                        Text(
                                            "\(userStats.net >= 0 ? "+" : "-")$\(String(format: "%.0f", abs(userStats.net)))"
                                        )
                                        .font(
                                            .custom(
                                                "comfortaa",
                                                size: geometry.size.width * 0.07
                                            )
                                        )
                                        .foregroundStyle(
                                            colorScheme == .light ? .black : .white
                                        )
                                    }
                                    .padding(
                                        .trailing,
                                        geometry.size.width * 0.05
                                    )
                                    
                                }

                                Text("Title: ")
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.035
                                        )
                                    )
                                    .foregroundStyle(
                                        Color.gray
                                    )
                                Text(game.sb_bb)
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.04
                                        )
                                    )
                                    .foregroundStyle(
                                        colorScheme == .light ? .black : .white
                                    )
                                                
                            }
                            .padding()
                            .background(.offBlack)
                            .cornerRadius(12)
                            .onTapGesture {
                                selected_game = game
                                selectedTab = .single_game_view
                            }
                        }
                            
                    }
                    .padding(.horizontal, geometry.size.width * 0.03)
                    
                    
                }
                .frame(maxWidth: .infinity)
            }
            .background(.colorScheme)
        }
    }
}

struct All_Games_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            All_Games_View(
                selectedTab: .constant(.buy_out),
                selected_game: 
                        .constant(
                            Game(
                                date: Date(),
                                title: "",
                                total_buy_in: 0,
                                total_buy_out: 0,
                                player_count: 0,
                                host_id: "",
                                sb_bb: "",
                                is_active: false,
                                users: [:]
                            )
                        )
            )
            .environmentObject(Authentication_View_Model())
            .environmentObject(Games_View_Model())
            .preferredColorScheme(.dark)
            All_Games_View(
                selectedTab: .constant(.buy_out),
                selected_game: 
                        .constant(
                            Game(
                                date: Date(),
                                title: "",
                                total_buy_in: 0,
                                total_buy_out: 0,
                                player_count: 0,
                                host_id: "",
                                sb_bb: "",
                                is_active: false,
                                users: [:]
                            )
                        )
            )
            .environmentObject(Authentication_View_Model())
            .environmentObject(Games_View_Model())
        }
    }
}
