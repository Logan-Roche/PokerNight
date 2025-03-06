//
//  Custom_Tab_Bar.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI

enum Tabs: Int {
    case chats = 0
    case contacts = 1
}

struct Custom_Tab_Bar: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        
        HStack (alignment:.center ) {
            
            
            Button() {
                selectedTab = .chats
                
            } label: {
                
               
                GeometryReader { geo in
                    
                    if selectedTab == .chats {
                        Rectangle()
                            .foregroundStyle(.gradientColorRight)
                            .frame(width: geo.size.width / 2, height: 4)
                            .padding(.leading, geo.size.width / 4)
                    }
                    
                    VStack (alignment: .center, spacing: 4) {
                        Image(systemName: "bubble.left")
                            .resizable()
                            .scaledToFit( )
                            .frame(width: 24, height:24)
                        
                        Text("Chats")
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                
                
            }
            .tint(.gray)
            
            Button {
                // New Game
                
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit( )
                        .frame(width: 32, height:32)
                    
                    Text("New Game")
                }
            }
            .tint(.gradientColorRight)
            
            
            Button() {
                selectedTab = .contacts
            } label: {
                
                
                    GeometryReader { geo in
                        if selectedTab == .contacts {
                            Rectangle()
                                .foregroundStyle(.gradientColorRight)
                                .frame(width: geo.size.width / 2, height: 4)
                                .padding(.leading, geo.size.width / 4)
                        }
                        VStack (alignment: .center, spacing: 4) {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit( )
                                .frame(width: 24, height:24)
                            
                            Text("Profile")
                        }
                        .frame(width: geo.size.width, height:geo.size.height)
                

                }
                            }
            .tint(.gray)
            
            
            
        }
        .frame(height: 82)
    }
}

struct Custom_Tab_Bar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Custom_Tab_Bar(selectedTab: .constant(.contacts))
                .preferredColorScheme(.dark)
            Custom_Tab_Bar(selectedTab: .constant(.contacts))
        }
    }
}
