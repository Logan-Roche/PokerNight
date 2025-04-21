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
                    
                    ZStack {
                        Rectangle()
                            .fill(.offBlack)
                            .frame(
                                height: geometry.size.height * 1
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: geometry.size.width * 0.07)
                            )
                            .shadow(color: .black.opacity(1), radius: 1, x: 0, y: 1)
                            .shadow(color: .black.opacity(1), radius: 1, x: 0, y: -1)
                            .offset(
                                y: geometry.size.height * 0.44
                            )
                        
                        Text("Stats")
                            .foregroundStyle(
                                colorScheme == .light ? .black : .white
                            )
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.09
                                )
                            )
                    }
                    .frame(maxHeight: geometry.size.height * 0.1)
                    .padding(.top, geometry.size.height * 0.03)
                    
                    ZStack {
                        Rectangle()
                            .fill(gradient)
                            .frame(
                                height: geometry.size.height * 0.2
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: geometry.size.width * 0.07)
                            )
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                            .padding(.horizontal, geometry.size.width * 0.03)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: -1)
                        
                        VStack {
                            Text("Net")
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                .font(
                                    .custom(
                                        "Roboto-bold",
                                        size: geometry.size.width * 0.06
                                        
                                    )
                                )
                                .padding(.top, geometry.size.height * 0.015)

                            Spacer()
                            
                            Text("\(game_view_model.totalProfit < 0 ? "-" : "")$\(String(format: "%.0f", abs(game_view_model.totalProfit)))")
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.14
                                    )
                                )
                                .padding(.bottom, geometry.size.height * 0.04)
                        }
                        


                    }
                    .padding(.bottom)
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(gradient)
                                .frame(
                                    height: geometry.size.height * 0.2
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: geometry.size.width * 0.07)
                                )
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                                .padding(.leading, geometry.size.width * 0.03)
                                .padding(.trailing, geometry.size.width * 0.015)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: -1)
                            VStack {
                                Text("Win Rate")
                                    .foregroundStyle(
                                        colorScheme == .light ? .black : .white
                                    )
                                    .font(
                                        .custom(
                                            "Roboto-bold",
                                            size: geometry.size.width * 0.05
                                            
                                        )
                                    )
                                    .padding(.top, geometry.size.height * 0.015)

                                Spacer()
                                
                                Text("\(String(format: "%.0f", game_view_model.winRate * 100))%")
                                    .foregroundStyle(
                                        colorScheme == .light ? .black : .white
                                    )
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.1
                                        )
                                    )
                                    .padding(.bottom, geometry.size.height * 0.06)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(gradient)
                                .frame(
                                    height: geometry.size.height * 0.2
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: geometry.size.width * 0.07)
                                )
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                                .padding(.trailing, geometry.size.width * 0.03)
                                .padding(.leading, geometry.size.width * 0.015)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: -1)
                            VStack {
                                Text("Avg ROI")
                                    .foregroundStyle(
                                        colorScheme == .light ? .black : .white
                                    )
                                    .font(
                                        .custom(
                                            "Roboto-bold",
                                            size: geometry.size.width * 0.05
                                            
                                        )
                                    )
                                    .padding(.top, geometry.size.height * 0.015)

                                Spacer()
                                
                                Text("\(String(format: "%.0f", game_view_model.averageROI * 100))%")
                                    .foregroundStyle(
                                        colorScheme == .light ? .black : .white
                                    )
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.1
                                        )
                                    )
                                    .padding(.bottom, geometry.size.height * 0.06)
                            }
                        }
                        
                    }
                    .padding(.bottom)
                    
                    ZStack {
                        Rectangle()
                            .fill(gradient)
                            .frame(
                                height: geometry.size.height * 0.2
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: geometry.size.width * 0.07)
                            )
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                            .padding(.horizontal, geometry.size.width * 0.03)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: -1)
                        
                        VStack {
                            Text("Total Games")
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                .font(
                                    .custom(
                                        "Roboto-bold",
                                        size: geometry.size.width * 0.06
                                        
                                    )
                                )
                                .padding(.top, geometry.size.height * 0.015)

                            Spacer()
                            
                            Text("\(game_view_model.totalGames)")
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.14
                                    )
                                )
                                .padding(.bottom, geometry.size.height * 0.04)
                        }
                    }
                    .padding(.bottom, geometry.size.height * 0.03)
                    
                    
                    Button {
                        selectedTab = .all_game_view
                    } label:{
                        Text("All Games")
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.05
                                )
                            )
                            .fontWeight(Font.Weight.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: geometry.size.height * 0.2
                            )
                            .background(.colorScheme)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: geometry.size.width * 0.04,
                            bottom: geometry.size.width * 0.01,
                            trailing: geometry.size.width * 0.04
                        )
                    )
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: -1)
                    .padding(.bottom)
                    
                    
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

