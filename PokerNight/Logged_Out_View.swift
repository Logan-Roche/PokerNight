//
//  Logged_Out_View.swift
//  PokerNight
//
//  Created by Logan Roche on 2/26/25.
//

import SwiftUI

struct Logged_Out_View: View {
        let background_color = Color(red: 23 / 255, green: 23 / 255, blue: 25 / 255)

        var body: some View {
            VStack {
                HStack  {
                    Image("Icon")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .scaledToFit()
                        .padding(.bottom, 15)
                        
                    Text("PokerNight")
                        .padding(.leading, 10)
                        .font(.custom("Comfortaa", size: 45))
                        .foregroundStyle(.white)
                }
                .padding(.top, 275)
                
                Spacer()
                
                VStack {
                    custom_button(title: "Log-In", backgroundColor: .black, action: {print("Log-In")})
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    custom_button(title: "Sign-In", backgroundColor: .black, action: {print("Log-In")})
                        .padding(.horizontal, 20)
                
                }
                .frame(maxWidth: .infinity, alignment: .bottom)
                .background(background_color)

                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("Log-Out Background Image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea())
        }
    }

#Preview {
    Logged_Out_View()
}
