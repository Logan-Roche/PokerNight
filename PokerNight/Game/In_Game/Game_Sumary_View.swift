//
//  Game_Sumary_View.swift
//  PokerNight
//
//  Created by Logan Roche on 4/15/25.
//

import SwiftUI

struct Game_Sumary_View: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Binding var selectedTab: Tabs
    
    @State var total_buy_in = 0.0
    @State var total_buy_out = 0.0
    @State var chip_error = 0.0
    @State var chip_error_divided = 0.0
    @State var eligibleUserCount = 0
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    Rectangle()
                        .fill(.offBlack)
                        .frame(
                            height: geometry.size.height * 1
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: geometry.size.width * 0.05)
                        )
                        .shadow(radius: 5)
                        .offset(
                            y: -geometry.size.height * 0.45
                        )
                    
                    Text("Game Summary")
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
                
                VStack {
                    LazyVGrid(columns: columns, spacing: geometry.size.width * 0.5) {
                        StatCard(title: "TOTAL BUY-IN", value: "$\(String(format: "%.2f",total_buy_in))")
                        StatCard(title: "TOTAL BUY-OUT", value: "$\(String(format: "%.2f",total_buy_out))")
                        StatCard(title: "CHIP ERROR", value: "$\(String(format: "%.2f",chip_error))")
                        StatCard(title: "CHIP ERROR DIVIDED", value: "$\(round(chip_error_divided * 100) / 100)")
                    }
                    .padding()
                    .padding(.bottom, geometry.size.height * 0.24)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Pay Out Summary")
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.073
                                )
                            )
                            .padding(
                                EdgeInsets(
                                    top: 0,
                                    leading: 0,
                                    bottom: geometry.size.height * 0.01,
                                    trailing: 0
                                )
                            )
                        
                        VStack {
                            Grid(
                                alignment: .center,
                                horizontalSpacing: 15,
                                verticalSpacing: 10
                            ) {
                                
                                
                                GridRow {
                                    Text("Name")
                                    Text("Buy Out")
                                    Text("Buy Out - Chip Error")
                                }
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.037
                                    )
                                )
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                
                                Divider()
                                
                                // Item Rows
                                ForEach(
                                    Array(game_view_model.game.users.keys).sorted(),
                                    id: \.self
                                ) { key in
                                    //ForEach(Array(sampleUsers.keys).sorted(), id: \.self) { key in
                                    
                                    if let stats = game_view_model.game.users[key] {
                                        //if let stats = sampleUsers[key] {
                                        
                                        GridRow {
                                            HStack {
                                                Text("\(stats.name)")
                                                    .font(
                                                        .custom(
                                                            "comfortaa",
                                                            size: geometry.size.width * 0.035
                                                        )
                                                    )
                                                    .foregroundStyle(
                                                        colorScheme == .light ? .black : .white
                                                    )
                                            }
                                            .padding(.vertical, 10)
                                            
                                            Text(
                                                "$\(stats.buy_out,specifier: "%.2f")"
                                            )
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .foregroundStyle(
                                                colorScheme == .light ? .black : .white
                                            )
                                            
                                            
                                            Text(
                                                "$\((stats.buy_out > 0.00001 ? stats.buy_out + chip_error_divided : stats.buy_out), specifier: "%.2f")"
                                            )
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .foregroundStyle(
                                                colorScheme == .light ? .black : .white
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(.offBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                    .shadow(color: .black.opacity(0.9), radius: 1, x: 0, y: -1) // subtle top glow
                    
                    Button {
                        // function that calls the are you sure sheet
                            // function that make users current game id = "", wipe the game_view_model.game so if they join another game it will not add the transactions, rerender the query of past game stats
                        game_view_model.Leave_Game(userId: auth_view_model.user!.uid)
                        selectedTab = .dashboard
                        
                                                
                    } label:{
                        Text("Leave Game")
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.05
                                )
                            )
                            .fontWeight(Font.Weight.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: geometry.size.height * 0.2
                            )
                            .background(gradient)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .padding(
                        EdgeInsets(
                            top: geometry.size.width * 0.04,
                            leading: geometry.size.width * 0.04,
                            bottom: geometry.size.width * 0.01,
                            trailing: geometry.size.width * 0.04
                        )
                    )
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: -1) // subtle top glow

                    
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(.colorScheme)
        .onAppear() {
            total_buy_in = game_view_model.game.users.values.reduce(0.0) { partialSum, userStats in
                partialSum + userStats.buy_in
            }
            total_buy_out = game_view_model.game.users.values.reduce(0.0) { partialSum, userStats in
                partialSum + userStats.buy_out
            }
            chip_error = total_buy_in - total_buy_out
            chip_error_divided = chip_error / Double(game_view_model.game.users.values.filter { $0.buy_out > 0.001 }.count)
            
            
        }
    }
}
    
    struct StatCard: View {
        var title: String
        var value: String
        
        var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    Text(title)
                        .font(
                            .custom(
                                "comfortaa",
                                size: geometry.size.width * 0.07
                            )
                        )
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Text(value)
                        .font(
                            .custom(
                                "comfortaa",
                                size: geometry.size.width * 0.2
                            )
                        )
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.width * 0.17)
                    
                    Spacer()
                }
                .padding()
                .frame(minWidth: geometry.size.width * 0.95, minHeight: geometry.size.width * 0.95)
                .background(Color(.offBlack))
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.width * 0.05))
                .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 4)
                .shadow(color: .black.opacity(0.9), radius: 1, x: 0, y: -1) // subtle top glow
            }
        }
    }
    
    struct Game_Sumary_ViewPreviews: PreviewProvider {
        static var previews: some View {
            Group {
                Game_Sumary_View(selectedTab: .constant(.dashboard))
                    .environmentObject(Games_View_Model())
                    .environmentObject(Authentication_View_Model())
                    .preferredColorScheme(.dark)
                
                Game_Sumary_View(selectedTab: .constant(.dashboard))
                    .environmentObject(Games_View_Model())
                    .environmentObject(Authentication_View_Model())
            }
        }
    }

