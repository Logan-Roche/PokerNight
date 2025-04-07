//
//  Profile_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI
import FirebaseAuth

struct Profile_View: View {
    
    @EnvironmentObject var game_view_model: Games_View_Model  // Use shared instance
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared
    
    
    var body: some View {
        VStack{
            Button("Log Out"){
                do {
                    try auth_view_model.Sign_Out()
                } catch let sign_our_error {
                    print(sign_our_error)
                }
            }
            .padding()
            .buttonStyle(.bordered)
            .tint(.red)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.colorScheme)
    }
}

struct Profile_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Profile_View()
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
                .preferredColorScheme(.dark)
            Profile_View()
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
        }
    }
}

