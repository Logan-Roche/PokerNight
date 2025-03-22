import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct In_Game_View: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var game_view_model: Games_View_Model  // Use shared instance
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
    
    @State private var current_user: User_Model?
    @State private var copied_to_clipboard = false
    
    let gradient = LinearGradient(colors: [.gradientColorLeft, .gradientColorRight], startPoint: .top, endPoint: .topTrailing)
    
    let sampleUsers: [String: Game.User_Stats] = [
        "Logan": Game.User_Stats(buy_in: 20, buy_out: 25.0, net: 5),
        "Ava": Game.User_Stats(buy_in: 40.0, buy_out: 15.0, net: -5.0),
        "Evan": Game.User_Stats(buy_in: 20.0, buy_out: 11.50, net: 8.5),
        "Dane": Game.User_Stats(buy_in: 20.0, buy_out: 0, net: -20)
    ]

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Rectangle()
                        .fill(gradient)
                        .frame(height: geometry.size.height * 0.2)  // 20% of screen height
                        .cornerRadius(geometry.size.width * 0.05)   // Corner radius relative to width
                        .shadow(radius: 5)
                    
                    Text(game_view_model.game.title)
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .font(.custom("comfortaa", size: geometry.size.width * 0.08))  // Font size based on width
                        .padding(.top, geometry.size.height * 0.05)
                }
                .padding(.bottom, geometry.size.height * 0.03)
                
                Button(action: {
                    // Copy to clipboard
                    UIPasteboard.general.string = game_view_model.currentGameID
                    
                    // Show the "Copied to Clipboard" overlay with animation
                    withAnimation(.smooth(duration: 0.5)) {
                        copied_to_clipboard = true
                    }
                    
                    // Hide the overlay after 1.5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.smooth(duration: 1)) {
                            copied_to_clipboard = false
                        }
                    }
                }) {
                    VStack {
                        Text("Copy Game Pin")
                            .font(.custom("comfortaa", size: geometry.size.width * 0.05))  // Dynamic font size
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                            .frame(alignment: .top)
                            .padding(EdgeInsets(top: geometry.size.height * 0.02, leading: 0, bottom: geometry.size.height * 0.015, trailing: 0))
                    }
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.07, alignment: .center)
                    .background(.offBlack)
                    .clipShape(Capsule())
                }
                .padding(.bottom, geometry.size.height * 0.03)
                
                VStack {
                    Text("Standings")
                        .font(.custom("comfortaa", size: geometry.size.width * 0.073))
                        .padding(EdgeInsets(top: geometry.size.height * 0.03, leading: 0, bottom: geometry.size.height * 0.015, trailing: 0))
                    
                    Grid(alignment: .center,
                         horizontalSpacing: 15,
                         verticalSpacing: 10) {
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
                        ForEach(Array(sampleUsers.keys), id: \.self) { key in
                            if let stats = sampleUsers[key] {
                                
                                GridRow {
                                    HStack {
                                        Text("\(key)")
                                            .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                            .foregroundStyle(colorScheme == .light ? .black : .white)
                                    }
                                    .padding(.vertical, geometry.size.height * 0.02)
                                    .frame(maxWidth: geometry.size.width * 0.25)
                                    
                                    Text("$\(stats.buy_in, specifier: "%.2f")")
                                        .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .frame(maxWidth: geometry.size.width * 0.25)
                                        
                                        
                                    
                                    Text("$\(stats.buy_out, specifier: "%.2f")")
                                        .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .frame(maxWidth: geometry.size.width * 0.25)
                                        
                                    
                                    
                                    Text("$\(stats.net, specifier: "%.2f")")
                                        .font(.custom("comfortaa", size: geometry.size.width * 0.035))
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .frame(maxWidth: geometry.size.width * 0.25)
                                        
                                }
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.5e, alignment: .top)
                .background(.offBlack)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorScheme)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                auth_view_model.fetchUserData { userModel in
                    current_user = userModel
                    if game_view_model.game.title.isEmpty {
                        game_view_model.Fetch_Game(gameId: game_view_model.currentGameID) { game, error in
                            if let error = error {
                                print("Failed to fetch game: \(error.localizedDescription)")
                            } else if let game = game {
                                print("Fetched game: \(game.title)")
                                game_view_model.game = game
                            }
                        }
                    }
                    print("User Model from fetchUserData: \(String(describing: current_user ?? userModel))")
                }
                game_view_model.startListening(gameId: game_view_model.currentGameID)
            }
            .onDisappear {
                //game_view_model.stopListening()
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
