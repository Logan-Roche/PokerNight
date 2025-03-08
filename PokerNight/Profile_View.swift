//
//  Profile_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI
import FirebaseAuth

struct Profile_View: View {
    private let auth = Auth.auth()
    
    
    var body: some View {
        VStack{
            Button("Log Out"){
                do {
                    try auth.signOut()
                    } catch let sign_our_error {
                        print(sign_our_error)
                    }
            }
            .padding()
            .buttonStyle(.bordered)
            .tint(.red)
            
            
            VStack{
                
            }
            .frame(width: 40, height: 40
            )
            .background(.offBlack)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.colorScheme)
    }
}

struct Profile_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Profile_View()
                .preferredColorScheme(.dark)
            Profile_View()
        }
    }
}

