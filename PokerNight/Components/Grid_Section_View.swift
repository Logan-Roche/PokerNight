//
//  Grid_Section_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/30/25.
//

import SwiftUI

struct Grid_Section_View: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var game_view_model: Games_View_Model  // Use shared instance
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Grid_Section_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Grid_Section_View()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
                .preferredColorScheme(.dark)
            
            Grid_Section_View()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
        }
    }
}
