//
//  Dashboard_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI
import FirebaseAuth

struct Dashboard_View: View {
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model 
    
    
    
    var body: some View {
        VStack {
            Text("Dashboard")
            Text(auth_view_model.user?.displayName ?? "")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.colorScheme)
    }
}

struct Dashboard_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Dashboard_View()
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
                .preferredColorScheme(.dark)
            Dashboard_View()
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
        }
    }
}
