import SwiftUI
import FirebaseAuth

private enum FocusableField: Hashable {
    case title
    case sb
    case bb
}

struct Start_Game_View: View {
    
    
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var interstital_ads_manager: InterstitialAdsManager
    @FocusState private var focus: FocusableField?
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    
    @State private var title: String = ""
    @State private var host_id = Auth.auth().currentUser?.uid ?? ""
    @State private var sb: String = ""
    @State private var bb: String = ""
    @State private var cents: Bool = true
    @State private var users: [String: User_Stats] = [:]
    @State private var transactions: [Transaction] = []
    
    @State private var game_id: String?
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    var isFormValid: Bool {
        !title.isEmpty && !sb.isEmpty && !bb.isEmpty
    }
    
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
                        
                        Text("Start Game")
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
                    .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Game Title")
                            .font(.custom("comfortaa", size: 17))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        
                        TextField("Enter Game Title", text: $title)
                            .focused($focus, equals: .title )
                            .submitLabel(.next)
                            .onSubmit {
                                self.focus = .sb
                            }
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
                                EdgeInsets(top: 0, leading: 1, bottom: 20, trailing: 1)
                            )
                        
                        Text("Small Blind")
                            .font(.custom("comfortaa", size: 17))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        
                        TextField("Enter SB Amount", text: $sb)
                            .keyboardType(.numberPad)
                            .focused($focus, equals: .sb )
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
                                EdgeInsets(top: 0, leading: 1, bottom: 20, trailing: 1)
                            )
                        
                        Text("Big Blind")
                            .font(.custom("comfortaa", size: 17))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        
                        TextField("Enter BB Amount", text: $bb)
                            .keyboardType(.numberPad)
                            .focused($focus, equals: .bb )
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
                            .padding(
                                EdgeInsets(top: 0, leading: 1, bottom: 20, trailing: 1)
                            )
                        
                        Text("Currency")
                            .font(.custom("comfortaa", size: 17))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        Picker("Currency",selection: $cents) {
                            Image(systemName: "centsign")
                                .tag(true)
                            
                            Image(systemName: "dollarsign")
                                .tag(false)
                            
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                    .padding(.horizontal)
                    
                    Button(
                        action: {
                            game_view_model.game.host_id = Auth.auth().currentUser!.uid
                            game_view_model.game.is_active = true
                            game_view_model.game.sb_bb = cents ? "\(sb)¢ / \(bb)¢" : "$\(sb) / $\(bb)"
                            game_view_model.game.title = title
                            game_view_model.game.date = Date()
                            
                            if auth_view_model.user!.uid != "nyyEs88t04eGTXlIKYYZqdXofib2"{
                                interstital_ads_manager.displayInterstitialAd()
                            }
                            
                            game_view_model
                                .Start_Game(game: game_view_model.game) { gameId in
                                    if let gameId = gameId {
                                        
                                        game_view_model.game.id = gameId
                                        game_view_model.currentGameID = gameId
                                        print(
                                            "New game ID: \(game_view_model.game.id ?? "No game ID")"
                                        )
                                        
                                        game_view_model
                                            .updateUserCurrentGame(
                                                newGameId: game_view_model.game.id ?? "No game ID"
                                            ) { success in
                                                if success {
                                                    print(
                                                        "Current game updated successfully"
                                                    )
                                                } else {
                                                    print(
                                                        "Failed to update current game"
                                                    )
                                                }
                                                
                                                game_view_model
                                                    .Add_or_Update_User_To_Game(
                                                        gameId: game_view_model.game.id ?? "temp",
                                                        user_id: Auth
                                                            .auth().currentUser!.uid,
                                                        user_stats: User_Stats(
                                                            name: auth_view_model.user!.displayName ?? "Unknown" ,
                                                            buy_in: 0,
                                                            buy_out: 0.00001,
                                                            net: 0.00001,
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
                                                        display_name: auth_view_model.user?.displayName ?? "",
                                                        type: "Joined Game: ",
                                                        amount: 0.001
                                                    ) {_ in
                                                    }
                                                game_view_model
                                                    .Fetch_Game(
                                                        gameId: game_view_model.currentGameID
                                                    ) {
                                                        game,
                                                        _ in
                                                        if let game = game {
                                                            game_view_model.game = game
                                                            game_view_model.game.id = game_view_model.currentGameID
                                                            game_view_model
                                                                .startListening(
                                                                    gameId: game_view_model.currentGameID
                                                                )
                                                            selectedTab = .in_game
                                                        }
                                                    }
                                                
                                            }
                                    } else {
                                        print("Failed to add game.")
                                    }
                                }
                            
                            
                            
                        }) {
                            Text("Start Game")
                                .font(.custom("Roboto", size: 17))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(gradient)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .opacity(isFormValid ? 1 : 0.5)
                        }
                        .padding(
                            EdgeInsets(top: 30, leading: 15, bottom: 15, trailing: 15)
                        )
                        .disabled(!isFormValid)
                    
                    Spacer()
                }
                .scrollDismissesKeyboard(.immediately)
            }
            
            .onAppear() {
                game_view_model.game = Game(date: Date(),
                                            title: "",
                                            host_id: "" ,
                                            sb_bb: "N/A",
                                            is_active: false,
                                            chip_error_divided: 0,
                                            users: [:],
                                            user_ids: [],
                                            transactions: [])
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorScheme)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Start_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Start_Game_View(selectedTab: .constant(.dashboard))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())  // Inject ViewModel in
                .preferredColorScheme(.dark)
            
            Start_Game_View(selectedTab: .constant(.dashboard))
                .environmentObject(Games_View_Model())  // Inject ViewModel in
                .environmentObject(Authentication_View_Model())
        }
    }
}
