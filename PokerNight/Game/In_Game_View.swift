import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct In_Game_View: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var game_view_model: Games_View_Model  // Use shared instance
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
    
    @State private var current_user: User_Model?
    @State private var copied_to_clipboard = false
    
    @State private var is_host: Bool = false
    
    let gradient = LinearGradient(colors: [.gradientColorLeft, .gradientColorRight], startPoint: .top, endPoint: .topTrailing)
    
    let sampleUsers: [String: Game.User_Stats] = [
        "Logan": Game.User_Stats(name: "Logan", buy_in: 20, buy_out: 25.0, net: 5, photo_url: ""),
        "ava": Game.User_Stats(name: "Ava", buy_in: 20, buy_out: 25.0, net: 5, photo_url: ""),
        "ddd": Game.User_Stats(name: "Evan", buy_in: 20, buy_out: 25.0, net: 5, photo_url: ""),
        "eee": Game.User_Stats(name: "Dane", buy_in: 20, buy_out: 25.0, net: 5, photo_url: ""),
        "fff": Game.User_Stats(name: "Dane", buy_in: 20, buy_out: 25.0, net: 5, photo_url: ""),
        "eaaee": Game.User_Stats(name: "Dane", buy_in: 20, buy_out: 25.0, net: 5, photo_url: ""),
        "edee": Game.User_Stats(name: "Dane", buy_in: 20, buy_out: 25.0, net: 5, photo_url: ""),
        "eeaeve": Game.User_Stats(name: "Dane", buy_in: 20, buy_out: 25.0, net: 5, photo_url: "")
    ]
    
    let sampleTransactions: [Transaction] = [
        Transaction(id: "1", userId: "user1", name: "Logan", type: 0, amount: 50.0, timestamp: Date()),
        Transaction(id: "2", userId: "user2", name: "Ava", type: 1, amount: 120.0, timestamp: Date().addingTimeInterval(-3600)),
        Transaction(id: "3", userId: "user3", name: "Evan", type: 0, amount: 30.0, timestamp: Date().addingTimeInterval(-7200)),
        Transaction(id: "4", userId: "user4", name: "Dane", type: 1, amount: 75.0, timestamp: Date().addingTimeInterval(-10800)),
        Transaction(id: "5", userId: "user5", name: "Liam", type: 0, amount: 40.0, timestamp: Date().addingTimeInterval(-14400)),
        Transaction(id: "6", userId: "user5", name: "Liam", type: 0, amount: 40.0, timestamp: Date().addingTimeInterval(-14400)),
        Transaction(id: "7", userId: "user5", name: "Liam", type: 0, amount: 40.0, timestamp: Date().addingTimeInterval(-14400)),
        Transaction(id: "8", userId: "user5", name: "Liam", type: 0, amount: 40.0, timestamp: Date().addingTimeInterval(-14400)),
        Transaction(id: "9", userId: "user5", name: "Liam", type: 0, amount: 40.0, timestamp: Date().addingTimeInterval(-14400)),
        Transaction(id: "10", userId: "user5", name: "Liam", type: 0, amount: 40.0, timestamp: Date().addingTimeInterval(-14400)),
    ]
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(gradient)
                            .frame(height: geometry.size.height * 1)  // 20% of screen height
                            .cornerRadius(geometry.size.width * 0.05)   // Corner radius relative to width
                            .shadow(radius: 5)
                            .offset(y: -geometry.size.height * 0.44) // Apply offset only to Rectangle
                        
                        Text(game_view_model.game.title)
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                            .font(.custom("comfortaa", size: geometry.size.width * 0.08))  // Font size based on width
                            .padding(.top, geometry.size.height * 0.05)
                    }
                    .frame(maxHeight: geometry.size.height * 0.2)
                    
                    
                    
                    // Copy Button
                    Button(action: {
                        // Copy to clipboard
                        UIPasteboard.general.string = game_view_model.currentGameID
                        
                        withAnimation(.smooth(duration: 0.5)) {
                            copied_to_clipboard = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.smooth(duration: 1)) {
                                copied_to_clipboard = false
                            }
                        }
                    }) {
                        VStack {
                            Text("Copy Game Pin")
                                .font(.custom("comfortaa", size: geometry.size.width * 0.05))
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                .frame(alignment: .top)
                                .padding(EdgeInsets(top: geometry.size.height * 0.02, leading: 0, bottom: geometry.size.height * 0.015, trailing: 0))
                        }
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.07, alignment: .center)
                        .background(.offBlack)
                        .clipShape(Capsule())
                    }
                    .padding(.bottom, geometry.size.height * 0.03)
                    
                     //Standings Section
                    VStack(alignment: .center, spacing: 10) {
                        Text("Standings")
                            .font(.custom("comfortaa", size: geometry.size.width * 0.073))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: geometry.size.height * 0.01, trailing: 0))
                        
                        VStack {
                            Grid(alignment: .center, horizontalSpacing: 15, verticalSpacing: 10) {
                                
                                // Column Headings
                                GridRow {
                                    Text("Name")
                                    Text("Buy In")
                                    Text("Buy Out")
                                    Text("Net")
                                }
                                .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                
                                Divider()
                                
                                // Item Rows
                                //ForEach(Array(game_view_model.game.users.keys), id: \.self) { key in
                                    ForEach(Array(sampleUsers.keys), id: \.self) { key in
                                    
//                                    if let stats = game_view_model.game.users[key] {
                                           if let stats = sampleUsers[key] {
                                        
                                        GridRow {
                                            HStack {
                                                Text("\(stats.name)")
                                                    .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                                    .foregroundStyle(colorScheme == .light ? .black : .white)
                                            }
                                            .padding(.vertical, 10)
                                            
                                            Text("$\(stats.buy_in, specifier: "%.2f")")
                                                .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                            
                                            Text("$\(stats.buy_out, specifier: "%.2f")")
                                                .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                            
                                            Text("$\(stats.net, specifier: "%.2f")")
                                                .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                        }
                                    }
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)  //  Grid only takes required height
                    }
                    .padding()
                    .background(.offBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                    
                    
                    VStack {
                        Text("Transactions")
                            .font(.custom("comfortaa", size: geometry.size.width * 0.073))
                            .padding(.bottom ,geometry.size.height * 0.02)
                        ScrollViewReader { scrollViewProxy in
                            
                            ScrollView {
                                LazyVGrid(columns: [GridItem(alignment:.leading) ], spacing: 10) {
                                    ForEach(sampleTransactions) { transaction in
                                        
                                        Text(transaction.name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                    }
                                    .frame(height: geometry.size.width * 0.08)
                                    .background(.offBlack)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                                .padding()
                            }
                            .onAppear {
                                if let lastTransaction = sampleTransactions.last {
                                    withAnimation {
                                        scrollViewProxy.scrollTo(lastTransaction.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.4)
                    .padding(EdgeInsets(top: geometry.size.height * 0.02, leading: 0, bottom: geometry.size.height * 0.02, trailing: 0))
                    
                    if is_host || true{
                        ZStack {
                            Rectangle()
                                .fill(.offBlack)
                                .frame(height: geometry.size.height * 0.5)  // 20% of screen height
                                .cornerRadius(geometry.size.width * 0.05)   // Corner radius relative to width
                                .shadow(radius: 5)
                                .offset(y: geometry.size.height * 0.44) // Apply offset only to Rectangle
                            
                        VStack {
                            Text("Actions")
                                .font(.custom("comfortaa", size: geometry.size.width * 0.073))
                                .padding(EdgeInsets(top: geometry.size.height * 0.02, leading: 0, bottom: geometry.size.height * 0.02, trailing: 0))
                            
                            HStack {
                                Button {
                                    
                                } label:{
                                    Text("Buy Out Player")
                                        .font(.custom("comfortaa", size: geometry.size.width * 0.05))
                                        .fontWeight(Font.Weight.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.2)
                                        .background(gradient)
                                        .cornerRadius(10)
                                        .shadow(radius: 3)
                                }
                                .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.04, bottom: 0, trailing: geometry.size.width * 0.02))
                                
                                
                                
                                Button {
                                    
                                } label:{
                                    Text("Edit")
                                        .font(.custom("comfortaa", size: geometry.size.width * 0.05))
                                        .fontWeight(Font.Weight.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.2)
                                        .background(gradient)
                                        .cornerRadius(10)
                                        .shadow(radius: 3)
                                }
                                .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.01, bottom: 0, trailing: geometry.size.width * 0.04))
                            }
                            
                            Button {
                                
                            } label:{
                                Text("Payout/End Game")
                                    .font(.custom("comfortaa", size: geometry.size.width * 0.05))
                                    .fontWeight(Font.Weight.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.2)
                                    .background(gradient)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                            .padding(EdgeInsets(top: geometry.size.width * 0.04, leading: geometry.size.width * 0.02, bottom: geometry.size.height * 0.05, trailing: geometry.size.width * 0.04))
                            
                            
                        }
                        .background(.offBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                        
                        
                    }

                }
                //.padding(.bottom, 30)  // Add padding to avoid content being cut off
                .frame(maxWidth: .infinity)
            }
            .background(.colorScheme)
            .edgesIgnoringSafeArea(.vertical)
            .onAppear {
                auth_view_model.fetchUserData { userModel in
                    current_user = userModel
                    game_view_model.Fetch_Game(gameId: game_view_model.currentGameID) { game, _ in
                        if let game = game {
                            game_view_model.game = game
                        }
                    }
                }
                game_view_model.startListening(gameId: game_view_model.currentGameID)
                
                if auth_view_model.user?.uid == game_view_model.game.host_id {
                    is_host = true
                }
            }
            
            .overlay {
                if copied_to_clipboard {
                    Text("Copied to Clipboard")
                        .font(.custom("comfortaa", size: geometry.size.width * 0.04))  // Dynamic font size
                        .foregroundStyle(.white)
                        .padding()
                        .background(gradient)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, geometry.size.height * 0.05)
                }
            }
        }
        
    }
}

struct In_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            In_Game_View()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
                .preferredColorScheme(.dark)
            
            In_Game_View()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
        }
    }
}
