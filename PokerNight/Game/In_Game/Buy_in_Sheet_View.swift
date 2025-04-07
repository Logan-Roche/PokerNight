import SwiftUI
import FirebaseAuth

struct Buy_in_Sheet_View: View {
    @Environment(\.colorScheme) var colorScheme
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""

    
    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                VStack{
                    Text("Enter Buy In")
                        .font(
                            .custom(
                                "comfortaa",
                                size: geometry.size.width * 0.073
                            )
                        )
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: geometry.size.height * 0.01,
                                trailing: 0
                            )
                        )
                    
                    TextField("Enter Buy In Amount", text: $amount)
                        .submitLabel(.next)
                        .keyboardType(.numberPad)
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
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: geometry.size.width * 0.04,
                                bottom: geometry.size.width * 0.03,
                                trailing: geometry.size.width * 0.04
                            )
                        )
                    
                    Button {
                        game_view_model
                            .Add_Transaction(
                                gameId: game_view_model.currentGameID,
                                user_id: auth_view_model.user?.uid ?? "",
                                type: game_view_model.game.users[Auth
                                    .auth().currentUser!.uid]!.buy_in == 0 ? "Buy In: " : "Re-Buy: ",
                                amount: Double(amount)
                            ) {_ in
                            }
                        
                        game_view_model
                            .Add_or_Update_User_To_Game(
                                gameId: game_view_model.game.id ?? " ",
                                user_id: Auth
                                    .auth().currentUser!.uid,
                                user_stats: User_Stats(
                                    name: auth_view_model.user!.displayName! ,
                                    buy_in: game_view_model.game.users[Auth
                                        .auth().currentUser!.uid]!.buy_in + Double(amount)!,
                                    buy_out: game_view_model.game.users[Auth
                                        .auth().currentUser!.uid]!.buy_out,
                                    net: game_view_model.game.users[Auth
                                        .auth().currentUser!.uid]!.buy_out,
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

                        dismiss()
                        
                    } label:{
                        Text("Buy In")
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorScheme)
        }
    }
}

struct Buy_in_Sheet_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Buy_in_Sheet_View()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
                .preferredColorScheme(.dark)
            
            Buy_in_Sheet_View()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
        }
    }
}
