//
//  Profile_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI
import FirebaseAuth
import _PhotosUI_SwiftUI

struct Profile_View: View {
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    
    
    @State private var selectedItem: PhotosPickerItem?
        @State private var selectedImage: UIImage?
    
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
                        Spacer()
                        Image(systemName: "gearshape")
                            .font(.system(size: geometry.size.width * 0.06))
                            .padding()
                            .gesture(TapGesture().onEnded {
                                selectedTab = .profile_settings
                            })
                    }
                    
                    if let url = auth_view_model.user?.photoURL {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .foregroundColor(.gray)
                    }
                    
                    Text(auth_view_model.user?.displayName ?? "Logan Roche")
                        .foregroundStyle(
                            colorScheme == .light ? .black : .white
                        )
                        .font(
                            .custom(
                                "comfortaa",
                                size: geometry.size.width * 0.08
                            )
                        )
                        .padding(.top, geometry.size.height * 0.02)
                    
                    
                    
                    
                }
                .frame(maxWidth: .infinity)
            }
            .background(.colorScheme)
        }
    }
}

struct Profile_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Profile_View(selectedTab: .constant(.buy_out))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
                .preferredColorScheme(.dark)
            Profile_View(selectedTab: .constant(.buy_out))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
        }
    }
}

