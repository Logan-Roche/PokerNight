import SwiftUI
import FirebaseAuth

struct Join_Game_View: View {
    
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
    @EnvironmentObject var game_view_model: Games_View_Model
    @Binding var selectedTab: Tabs
    
    @State private var current_user: User_Model?
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var game_pin: String = ""
     
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Enter Game Pin")
                    .font(
                        .custom(
                            "comfortaa",
                            size: geometry.size.width * 0.073
                        )
                    )
                    .padding(.top, geometry.size.height * 0.02)
                
                TextField("Enter Game Pin", text: $game_pin)
                    .submitLabel(.done)
                    .padding()
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
                    .padding()
                
                Button {
                    
                        auth_view_model.fetchUserData { userModel in
                            current_user = userModel
                            game_view_model
                                .Fetch_Game(gameId: game_pin) { game, _ in
                                    if let game = game {
                                        game_view_model.game = game
                                    }
                                }
                            game_view_model
                                .updateUserCurrentGame(newGameId: game_view_model.game.id!) { success in
                                    if success {
                                        print(
                                            "Current game updated successfully"
                                        )
                                    } else {
                                        print("Failed to update current game")
                                    }
                                }
                            game_view_model
                                .Add_or_Update_User_To_Game(
                                    gameId: game_view_model.game.id ?? " ",
                                    user_id: Auth
                                        .auth().currentUser!.uid,
                                    user_stats: User_Stats(
                                        name: auth_view_model.user!.displayName! ,
                                        buy_in: 0,
                                        buy_out: 0,
                                        net: 0,
                                        photo_url: auth_view_model.user?.photoURL?.absoluteString ?? ""
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
                            game_view_model
                                .Add_Transaction(
                                    gameId: game_view_model.currentGameID,
                                    user_id: auth_view_model.user?.uid ?? "",
                                    type: "Joined Game: ",
                                    amount: 0.001
                                ) {_ in
                                }
                            dismiss()
                            selectedTab = .in_game
                        }
                } label:{
                    Text("Join Game")
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
                            maxHeight: geometry.size.height * 0.3
                        )
                        .background(gradient)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .lineLimit(nil)
                }
                .padding(
                    EdgeInsets(
                        top: 0,
                        leading: geometry.size.width * 0.04,
                        bottom: geometry.size.width * 0.01,
                        trailing: geometry.size.width * 0.04
                    )
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.offBlack)
            .navigationBarBackButtonHidden(true)
        }
        
        
    }
    
}

struct Join_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Join_Game_View(selectedTab: .constant(.dashboard))
                .preferredColorScheme(.dark)
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
                
            Join_Game_View(selectedTab: .constant(.dashboard))
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
        }
    }
}
