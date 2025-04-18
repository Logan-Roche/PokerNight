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
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    @Binding var totalGames: Int
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    
    
    
    

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                      Image("Icon")
                            .resizable()
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                        
                        if let url = auth_view_model.user?.photoURL {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                            .clipShape(Circle())
                            .padding()
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .frame(alignment: .leading)
                    
                    Text("Total Games: \(totalGames)")
                    
                    
                    
                }
                .frame(maxWidth: .infinity)
            }
            .background(.colorScheme)
            
        }
    }
}

struct Dashboard_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Dashboard_View(selectedTab: .constant(.dashboard), totalGames: .constant(10))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
                .preferredColorScheme(.dark)
            Dashboard_View(selectedTab: .constant(.dashboard), totalGames: .constant(10))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
        }
    }
}
