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
                                StatCard(title: "TOTAL BUY-IN", value: "$320")
                                StatCard(title: "TOTAL BUY-OUT", value: "$325")
                                StatCard(title: "CHIP ERROR", value: "$5")
                                StatCard(title: "CHIP ERROR DIVIDED", value: "$1.25")
                            }
                            .padding()
                            //.background(Color(.black))
                        }
                }
                .frame(maxWidth: .infinity)
            }
            .background(.colorScheme)
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
