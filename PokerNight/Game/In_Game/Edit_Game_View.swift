import SwiftUI
import FirebaseAuth

struct Edit_Game_View: View {
    
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
    @EnvironmentObject var game_view_model: Games_View_Model
    @Binding var selectedTab: Tabs
    
    @Environment(\.colorScheme) var colorScheme
    
    
    @State private var title: String = ""
    @State private var sb: String = ""
    @State private var bb: String = ""
    @State private var buy_in: String = ""
    @State private var cents: Bool = true
    @State private var users: [String: User_Stats] = [:]
    @State private var transactions: [Transaction] = []
    
    @State private var old_title: String = ""
    @State private var old_sb: String = ""
    @State private var old_bb: String = ""
    @State private var old_buy_in: String = ""
    
    @State private var selectedPlayerID: String? = nil
    
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    ZStack {
                        Rectangle()
                            .fill(.offBlack)
                            .frame(
                                height: geometry.size.height * 1
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: geometry.size.width * 0.05)
                            )
                            .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 3)
                            .offset(
                                y: -geometry.size.height * 0.45
                            )
                        
                        Text("Edit Game")
                            .foregroundStyle(
                                colorScheme == .light ? .black : .white
                            )
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.08
                                )
                            )
                            .padding(.top, geometry.size.height * 0.01)
                    }
                    .frame(maxHeight: geometry.size.height * 0.05)
                    .padding(.bottom, geometry.size.height * 0.06)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Game Title")
                            .font(.custom("comfortaa", size: 17))
                            .foregroundColor(
                                colorScheme == .light ? .black : .white
                            )
                            .padding(.horizontal)
                        
                        TextField("Enter Game Title", text: $title)
                        
                            .submitLabel(.next)
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
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        
                        Text("Small Blind")
                            .font(.custom("comfortaa", size: 17))
                            .foregroundColor(
                                colorScheme == .light ? .black : .white
                            )
                            .padding(.horizontal)
                        
                        TextField("Enter SB Amount", text: $sb)
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
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        
                        Text("Big Blind")
                            .font(.custom("comfortaa", size: 17))
                            .foregroundColor(
                                colorScheme == .light ? .black : .white
                            )
                            .padding(.horizontal)
                        
                        TextField("Enter BB Amount", text: $bb)
                            .keyboardType(.numberPad)
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
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        
                    }
                    
                    Text("Currency")
                        .font(.custom("comfortaa", size: 17))
                        .foregroundColor(
                            colorScheme == .light ? .black : .white
                        )
                    Picker("Currency",selection: $cents) {
                        Image(systemName: "centsign")
                            .tag(true)
                        
                        Image(systemName: "dollarsign")
                            .tag(false)
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    VStack {
                        Text("Edit Buy In")
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
                                                buy_in = String(game_view_model.game.users[userID]!.buy_in)
                                                old_buy_in = String(game_view_model.game.users[userID]!.buy_in)
                                            }
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        
                    }
                    .background(.offBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                    .shadow(color: .black.opacity(0.9), radius: 1, x: 0, y: -1) // subtle top glow
                    .padding(.vertical, geometry.size.height * 0.03)
                    
                    TextField("Enter Buy In Amount", text: $buy_in)
                        .keyboardType(.decimalPad)
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
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    
                    
                    Button(
                        action: {
                            game_view_model.game.title = title
                            game_view_model.game.sb_bb = cents ? "\(sb)¢ / \(bb)¢" : "$\(sb) / $\(bb)"
                            
                            if let id = selectedPlayerID, let buyIn = Double(buy_in) {
                                game_view_model.game.users[id]?.buy_in = buyIn
                            }

                            game_view_model.editGame(game: game_view_model.game)

                            // 💡 Define gameEditType HERE
                            let gameEditType: String = {
                                var components: [String] = []

                                if title != old_title {
                                    components.append("Title")
                                }

                                if sb != old_sb || bb != old_bb {
                                    components.append("Blinds")
                                }

                                if let id = selectedPlayerID, buy_in != old_buy_in {
                                    let name = game_view_model.game.users[id]?.name ?? "Unknown"
                                    let buyInChange = "Buy-In: \(name), $\(old_buy_in) -> $\(buy_in)"
                                    
                                    if title == old_title && sb == old_sb && bb == old_bb {
                                        components.append("\n\(buyInChange)")
                                    }
                                }

                                return "Game Edit: \(components.joined(separator: ", "))"
                            }()

                            game_view_model.Add_Transaction(
                                gameId: game_view_model.currentGameID,
                                user_id: game_view_model.game.host_id,
                                display_name: game_view_model.game.users[game_view_model.game.host_id]?.name ?? "Unknown",
                                type: gameEditType,
                                amount: 0.002
                            ) { _ in }

                            selectedTab = .in_game
                        }
                    ){
                            Text("Edit Game")
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.05
                                    )
                                )
                                .fontWeight(Font.Weight.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, geometry.size.height * 0.2)
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: geometry.size.height * 0.2
                                )
                                .background(gradient)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                        .shadow(color: .offBlack.opacity(0.5), radius: 1, x: 0, y: 1)
                        .shadow(color: .offBlack.opacity(0.3), radius: 1, x: 0, y: -1)
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: geometry.size.width * 0.04,
                                bottom: geometry.size.width * 0.01,
                                trailing: geometry.size.width * 0.04
                            )
                        )
                    
                    
                    
                    Spacer()
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .frame(maxWidth: .infinity)
            
        }
        .background(.colorScheme)
        //.edgesIgnoringSafeArea(.vertical)
        .onAppear() {
            title = game_view_model.game.title
            old_title = game_view_model.game.title
            let parts = game_view_model.game.sb_bb.components(separatedBy: " / ")
            
            if parts.count == 2 {
                let rawSB = parts[0]
                let rawBB = parts[1]
                
                // Remove the currency symbols
                sb = rawSB.trimmingCharacters(in: CharacterSet(charactersIn: "$¢"))
                old_sb = rawSB.trimmingCharacters(in: CharacterSet(charactersIn: "$¢"))
                bb = rawBB.trimmingCharacters(in: CharacterSet(charactersIn: "$¢"))
                old_bb = rawBB.trimmingCharacters(in: CharacterSet(charactersIn: "$¢"))
            }
            cents = game_view_model.game.sb_bb.contains("¢")
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
    
    struct Edit_Game_View_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                Edit_Game_View(selectedTab: .constant(.dashboard))
                    .preferredColorScheme(.dark)
                    .environmentObject(Games_View_Model())
                    .environmentObject(Authentication_View_Model())
                
                Edit_Game_View(selectedTab: .constant(.dashboard))
                    .environmentObject(Games_View_Model())
                    .environmentObject(Authentication_View_Model())
            }
        }
    }

