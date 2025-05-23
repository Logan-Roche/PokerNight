//
//  Custom_Tab_Bar.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI
import FirebaseAuth

enum Tabs: Int {
    case dashboard = 0
    case profile = 1
    case start_game = 2
    case in_game = 3
    case buy_out = 4
    case edit_game = 5
    case game_summary = 6
    case profile_settings = 7
    case all_game_view = 8
    case single_game_view = 9
}

struct Custom_Tab_Bar: View {
    
    @Binding var selectedTab: Tabs
    @Binding var start_game_join_game_sheet: Bool
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @EnvironmentObject var game_view_model: Games_View_Model
    
    @State var currentUser: User_Model?
    
    var body: some View {
        
        HStack (alignment:.center ) {
            
            
            Button() {
                selectedTab = .dashboard
                
            } label: {
                
                
                Custom_Tab_Bar_Button(image_name: "house",
                                      is_active: selectedTab == .dashboard )
            }
            .tint(.gray)
            
            if (game_view_model.currentGameID == "") {
                Button {
                    start_game_join_game_sheet.toggle()
                    
                } label: {
                    VStack (alignment: .center, spacing: 4) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit( )
                            .frame(width: 15, height:15)
                            .foregroundStyle(
                                colorScheme == .light ? Color.black : Color.white
                            )
                        
                    }
                    .clipShape(Capsule())
                }
                .tint(.gradientColorRight)
                .frame(width: 68, height: 40)
                .background(gradient)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                .shadow(
                    color: .black.opacity(0.5),
                    radius: 1,
                    x: 0,
                    y: -1
                ) // subtle top glow
            }
            else {
                Button {
                    selectedTab = .in_game
                    
                } label: {
                    VStack (alignment: .center, spacing: 4) {
                        Image(systemName: "suit.spade.fill")
                            .resizable()
                            .scaledToFit( )
                            .frame(width: 15, height:15)
                            .foregroundStyle(
                                colorScheme == .light ? Color.black : Color.white
                            )
                        
                    }
                    .clipShape(Capsule())
                }
                .tint(.gradientColorRight)
                .frame(width: 68, height: 40)
                .background(gradient)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                .shadow(
                    color: .black.opacity(0.5),
                    radius: 1,
                    x: 0,
                    y: -1
                ) // subtle top glow
                
            }
            
            
            Button() {
                selectedTab = .profile
            } label: {
                
                
                Custom_Tab_Bar_Button(image_name: "person",
                                      is_active: selectedTab == .profile )
            }
            .tint(.gray)
            
            
            
        }
        .frame(height: 70)
        .background(.offBlack)
        .onAppear {
            // old: if auth_view_model.user?.uid == "" {
            if auth_view_model.user == nil {        // runs exactly once per cold launch
                auth_view_model.fetchUserData { userModel in
                    currentUser = userModel
                }
            }
        }
    }
}


struct Custom_Tab_Bar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Custom_Tab_Bar(
                selectedTab: .constant(.profile),
                start_game_join_game_sheet: .constant(false)
            )
            .environmentObject(Games_View_Model())
            .environmentObject(Authentication_View_Model())
            .preferredColorScheme(.dark)
            Custom_Tab_Bar(
                selectedTab: .constant(.profile),
                start_game_join_game_sheet: .constant(false)
            )
            .environmentObject(Games_View_Model())
            .environmentObject(Authentication_View_Model())
        }
    }
}
