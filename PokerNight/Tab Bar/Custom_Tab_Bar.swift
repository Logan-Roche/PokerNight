//
//  Custom_Tab_Bar.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI

enum Tabs: Int {
    case dashboard = 0
    case profile = 1
    case start_game = 2
}

struct Custom_Tab_Bar: View {
    
    @Binding var selectedTab: Tabs
    @Binding var start_game_join_game_sheet: Bool
    let gradient = LinearGradient(colors: [.gradientColorLeft, .gradientColorRight], startPoint: .top, endPoint: .topTrailing)
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack (alignment:.center ) {
            
            
            Button() {
                selectedTab = .dashboard
                
            } label: {
                
                
                Custom_Tab_Bar_Button(image_name: "house",
                                      is_active: selectedTab == .dashboard )
            }
            .tint(.gray)
            
            Button {
                start_game_join_game_sheet.toggle()
                
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit( )
                        .frame(width: 15, height:15)
                        .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                    
                }
                .clipShape(Capsule())
            }
            .tint(.gradientColorRight)
            .frame(width: 68, height: 40)
            .background(gradient)
            .clipShape(Capsule())
            
            
            
            
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
    }
}

struct Custom_Tab_Bar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Custom_Tab_Bar(selectedTab: .constant(.profile),start_game_join_game_sheet: .constant(false))
                .preferredColorScheme(.dark)
            Custom_Tab_Bar(selectedTab: .constant(.profile),start_game_join_game_sheet: .constant(false))
        }
    }
}
