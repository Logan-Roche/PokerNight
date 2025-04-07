//
//  Buy_Out_View.swift
//  PokerNight
//
//  Created by Logan Roche on 4/6/25.
//

import SwiftUI
import FirebaseAuth


struct Buy_Out_View: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Binding var selectedTab: Tabs
    
    @FocusState var isFocused: Bool
    
    @State private var amount: String = ""
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    
    @State private var selectedPlayerID: String? = nil
    
    let photoURL = "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"
            
            let users: [String: User_Stats] = [
                "1": User_Stats(name: "Ava Bailey", buy_in: 100, buy_out: 150, net: 50, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"),
                "2": User_Stats(name: "Evan Goertzen", buy_in: 100, buy_out: 80, net: -20, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"),
                "3": User_Stats(name: "Will McClure", buy_in: 150, buy_out: 200, net: 50, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"),
                "4": User_Stats(name: "Joe Roche", buy_in: 90, buy_out: 60, net: -30, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"),
                "5": User_Stats(name: "David Levintov", buy_in: 110, buy_out: 130, net: 20, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"),
                "6": User_Stats(name: "Dane Baker", buy_in: 120, buy_out: 170, net: 50, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"),
                "7": User_Stats(name: "Kayla Owens", buy_in: 100, buy_out: 100, net: 0, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c"),
                "8": User_Stats(name: "Liam Smith", buy_in: 80, buy_out: 50, net: -30, photo_url: "https://lh3.googleusercontent.com/a/ACg8ocJfQuZISYcDaesObey16ljzX2-2BY9s-82558N6I23GjNn0gVzG=s96-c")
            ]
    
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    ZStack {
                        Rectangle()
                            .fill(.offBlack)
                            .frame(
                                height: geometry.size.height * 0.95
                            )
                            .cornerRadius(
                                geometry.size.width * 0.05
                            )
                            .shadow(radius: 5)
                            .offset(y: -geometry.size.height * 0.4)
                        
                        Text("Buy Out Player")
                            .foregroundStyle(
                                colorScheme == .light ? .black : .white
                            )
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.08
                                )
                            )
                            .padding(.top, geometry.size.height * 0.08)
                    }
                    .frame(maxHeight: geometry.size.height * 0.15)
                    
                    
                    
                    VStack {
                        Text("Select Player")
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.073
                                )
                            )
                            .padding(
                                EdgeInsets(
                                    top: geometry.size.height * 0.03,
                                    leading: 0,
                                    bottom: geometry.size.height * 0.01,
                                    trailing: 0
                                )
                            )
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [GridItem(.fixed(geometry.size.width * 0.3)), GridItem(.fixed(geometry.size.width * 0.3))], spacing: 24) {
                                ForEach(Array(game_view_model.game.users.keys), id: \.self) { userID in
                                    //ForEach(Array(users.keys).sorted(), id: \.self) { userID in
                                    if let user = game_view_model.game.users[userID] {
                                        //if let user = users[userID] {
                                        PlayerCard(user: user, isSelected: selectedPlayerID == userID)
                                            .onTapGesture {
                                                selectedPlayerID = userID
                                            }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .background(.offBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.vertical, geometry.size.height * 0.03)
                    
                    Text("Buy Out Amount")
                        .font(
                            .custom(
                                "comfortaa",
                                size: geometry.size.width * 0.073
                            )
                        )
                        .padding(.bottom, geometry.size.height * 0.01)
                    
                    TextField("Enter Buy Out", text: $amount)
                        .focused($isFocused, equals: true )
                        .submitLabel(.done)
                        .padding()
                        .keyboardType(.decimalPad)
                        .background(.offBlack)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(
                                    colorScheme == .light ? .gray : .black,
                                    lineWidth: 1.5
                                )
                        )
                        .foregroundColor(.gray)
                        .font(.custom("roboto-regular", size: 15))
                        .padding(.horizontal)
                        .scrollDismissesKeyboard(.immediately)
                    
                    
                    
                    Button {
                        game_view_model
                            .Add_Transaction(
                                gameId: game_view_model.currentGameID,
                                user_id: selectedPlayerID!,
                                type: "Buy Out: ",
                                amount: Double(amount)
                            ) {_ in
                            }
                        
                        game_view_model
                            .Add_or_Update_User_To_Game(
                                gameId: game_view_model.game.id ?? " ",
                                user_id: selectedPlayerID!,
                                user_stats: User_Stats(
                                    name: game_view_model.game.users[selectedPlayerID!]!.name ,
                                    buy_in: game_view_model.game.users[selectedPlayerID!]!.buy_in,
                                    buy_out: Double(amount)!,
                                    net: Double(amount)! - game_view_model.game.users[selectedPlayerID!]!.buy_in,
                                    photo_url: game_view_model.game.users[selectedPlayerID!]?.photo_url ?? ""
                                )
                            ){ error in
                                if let error = error {
                                    print(
                                        "Failed to add user: \(error.localizedDescription)"
                                    )
                                } else {
                                    print(
                                        "User added/updated successfully!"
                                    )
                                }
                            }
                        selectedTab = .in_game
                        
                    } label:{
                        Text("Buy Out")
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
                                maxHeight: geometry.size.height * 0.1
                            )
                            .background(gradient)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .padding(
                        EdgeInsets(
                            top: geometry.size.width * 0.04,
                            leading: geometry.size.width * 0.04,
                            bottom: geometry.size.width * 0.01,
                            trailing: geometry.size.width * 0.04
                        )
                    )
                    
                    
                    
                    
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorScheme)
            .edgesIgnoringSafeArea(.vertical)
            .scrollDismissesKeyboard(.immediately)
        
        }
    }
    
    struct PlayerCard: View {
        let user: Game.User_Stats
        //let user: User_Stats
        let isSelected: Bool
        
        var body: some View {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: user.photo_url)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.colorScheme
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.gradientColorLeft.opacity(0.8) : Color.clear, lineWidth: 5)
                )
                
                Text(user.name)
                    .font(.custom("comfortaa", size: 12))
                    .frame(width: 100)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(4)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(16)
        }
    }
    
}

struct Buy_Out_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Buy_Out_View(selectedTab: .constant(.dashboard))
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
                .preferredColorScheme(.dark)
            
            Buy_Out_View(selectedTab: .constant(.dashboard))
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
        }
    }
}
