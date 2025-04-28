import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct In_Game_View: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @EnvironmentObject var interstital_ads_manager: InterstitialAdsManager
    @Binding var selectedTab: Tabs
    
    @State private var current_user: User_Model?
    @State private var copied_to_clipboard = false
    @State private var show_buy_in_sheet: Bool = false

    
    @State private var is_host: Bool = false
    @State private var loaded: Bool = false
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(gradient)
                            .frame(
                                height: geometry.size.height * 1
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: geometry.size.width * 0.05
                                )
                            )
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 3,
                                x: 0,
                                y: 3
                            )
                            .offset(
                                y: -geometry.size.height * 0.44
                            )
                        
                        Text(game_view_model.game.title)
                            .foregroundStyle(
                                colorScheme == .light ? .black : .white
                            )
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.08
                                )
                            )
                            .padding(.top, geometry.size.height * 0.05)
                    }
                    .frame(maxHeight: geometry.size.height * 0.2)
                    
                    
                    
                    // Copy Button
                    Button(action: {
                        
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
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.05
                                    )
                                )
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                .frame(alignment: .top)
                                .padding(
                                    EdgeInsets(
                                        top: geometry.size.height * 0.02,
                                        leading: 0,
                                        bottom: geometry.size.height * 0.015,
                                        trailing: 0
                                    )
                                )
                        }
                        .frame(
                            width: geometry.size.width * 0.5,
                            height: geometry.size.height * 0.07,
                            alignment: .center
                        )
                        .background(.offBlack)
                        .clipShape(Capsule())
                        .shadow(
                            color: .black.opacity(0.8),
                            radius: 1,
                            x: 0,
                            y: 1
                        )
                        .shadow(
                            color: .black.opacity(0.9),
                            radius: 1,
                            x: 0,
                            y: -1
                        )
                    }
                    .padding(.bottom, geometry.size.height * 0.03)
                    
                    // Standing Section
                    VStack(alignment: .center, spacing: 10) {
                        Text("Standings")
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
                        
                        VStack {
                            Grid(
                                alignment: .center,
                                horizontalSpacing: 15,
                                verticalSpacing: 10
                            ) {
                                
                                
                                GridRow {
                                    Text("Name")
                                    Text("Buy In")
                                    Text("Buy Out")
                                    Text("Net")
                                }
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.035
                                    )
                                )
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                
                                Divider()
                                
                                // Item Rows
                                ForEach(
                                    Array(game_view_model.game.users.keys)
                                        .sorted(),
                                    id: \.self
                                ) { key in
                                    //ForEach(Array(sampleUsers.keys).sorted(), id: \.self) { key in
                                    
                                    if let stats = game_view_model.game.users[key] {
                                        //if let stats = sampleUsers[key] {
                                        
                                        GridRow {
                                            HStack {
                                                Text("\(stats.name)")
                                                    .font(
                                                        .custom(
                                                            "comfortaa",
                                                            size: geometry.size.width * 0.035
                                                        )
                                                    )
                                                    .foregroundStyle(
                                                        colorScheme == .light ? .black : .white
                                                    )
                                            }
                                            .padding(.vertical, 10)
                                            
                                            Text(
                                                "$\(stats.buy_in,specifier: "%.2f")"
                                            )
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .foregroundStyle(
                                                colorScheme == .light ? .black : .white
                                            )
                                            
                                            Text(
                                                stats.buy_out != 0.00001
                                                ? "$\(String(format: "%.2f", stats.buy_out))"
                                                : "N/A"
                                            )
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .foregroundStyle(
                                                colorScheme == .light ? .black : .white
                                            )
                                            
                                            Text(
                                                stats.net != 0.00001
                                                ? "$\(String(format: "%.2f", stats.net))"
                                                : "N/A"
                                            )
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .foregroundStyle(
                                                colorScheme == .light ? .black : .white
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(.offBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                    .shadow(
                        color: .black.opacity(0.9),
                        radius: 1,
                        x: 0,
                        y: -1
                    ) // subtle top glow
                    
                    VStack {
                        Text("Transactions")
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.073
                                )
                            )
                            .padding(.bottom ,geometry.size.height * 0.02)
                            
                        ScrollViewReader { scrollViewProxy in
                            ScrollView {
                                LazyVGrid(
                                    columns: [GridItem(alignment:.leading) ],
                                    spacing: 10
                                ) {
                                    ForEach(
                                        game_view_model.game.transactions,
                                        id: \.id
                                    ) { transaction in
                                        HStack {
                                            Text(
                                                "\(transaction.type)\(transaction.amount != 0.002 ? transaction.name: "")\((transaction.amount != 0.001 && transaction.amount != 0.002) ? ", $\(String(format: "%.2f", transaction.amount!))" : "")"
                                            )
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading
                                            )
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .padding(
                                                .leading,
                                                geometry.size.width * 0.02
                                            )
                                                
                                            Text(
                                                "\(transaction.timestamp.formatted(date: .omitted, time: .shortened))"
                                            )
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.035
                                                )
                                            )
                                            .padding(
                                                .trailing,
                                                geometry.size.width * 0.02
                                            )
                                            .foregroundStyle(.gray)
                                        }
                                    }
                                    .frame(height: geometry.size.width * 0.08)
                                    .background(.offBlack)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 4)
                                    )
                                    .shadow(
                                        color: .black.opacity(0.8),
                                        radius: 1,
                                        x: 0,
                                        y: 1
                                    )
                                    .shadow(
                                        color: .black.opacity(0.9),
                                        radius: 1,
                                        x: 0,
                                        y: -1
                                    ) // subtle top glow
                                }
                                .padding()
                            }
                            .onAppear {
                                if let lastTransaction = game_view_model.game.transactions.last {
                                    withAnimation {
                                        scrollViewProxy
                                            .scrollTo(
                                                lastTransaction.id,
                                                anchor: .bottom
                                            )
                                    }
                                }
                            }
                            .onChange(
                                of: game_view_model.game.transactions.count
                            ) {
                                _,
                                _ in
                                if let lastTransaction = game_view_model.game.transactions.last {
                                    withAnimation {
                                        scrollViewProxy
                                            .scrollTo(
                                                lastTransaction.id,
                                                anchor: .bottom
                                            )
                                    }
                                }
                            }
                                
                                
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: geometry.size.height * 0.5
                    )
                    .padding(
                        EdgeInsets(
                            top: geometry.size.height * 0.02,
                            leading: 0,
                            bottom: geometry.size.width * 0.02,
                            trailing: 0
                        )
                    )
                    

                    
                    
                    ZStack {
                        Rectangle()
                            .fill(.offBlack)
                            .frame(height: geometry.size.height * 0.4)
                            .offset(y: geometry.size.height * 0.30)
                            .shadow(
                                color: .black.opacity(0.9),
                                radius: 1,
                                x: 0,
                                y: -1
                            ) // subtle top glow
                        
                        VStack {
                            Text("Actions")
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.073
                                    )
                                )
                                .padding(
                                    EdgeInsets(
                                        top: geometry.size.height * 0.02,
                                        leading: 0,
                                        bottom: geometry.size.height * 0.02,
                                        trailing: 0
                                    )
                                )
                            
                            Button {
                                
                                show_buy_in_sheet.toggle()
                                                        
                            } label:{
                                Text("Buy In")
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.05
                                        )
                                    )
                                    .fontWeight(Font.Weight.bold)
                                    .foregroundColor(
                                        colorScheme == .light ? .black : .white
                                    )
                                    .padding()
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: geometry.size.height * 0.2
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
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 1,
                                x: 0,
                                y: 1
                            )
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 1,
                                x: 0,
                                y: -1
                            ) // subtle top glow
                            
                            if is_host {
                                HStack {
                                    Button {
                                        selectedTab = .buy_out
                                    } label:{
                                        Text("Buy Out")
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.05
                                                )
                                            )
                                            .fontWeight(Font.Weight.bold)
                                            .foregroundColor(
                                                colorScheme == .light ? .black : .white
                                            )
                                            .padding()
                                            .frame(
                                                maxWidth: .infinity,
                                                maxHeight: geometry.size.height * 0.2
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
                                            trailing: geometry.size.width * 0.01
                                        )
                                    )
                                    .shadow(
                                        color: .black.opacity(0.5),
                                        radius: 1,
                                        x: 0,
                                        y: 1
                                    )
                                    .shadow(
                                        color: .black.opacity(0.5),
                                        radius: 1,
                                        x: 0,
                                        y: -1
                                    ) // subtle top glow
                                    
                                    
                                    
                                    
                                    
                                    Button {
                                        selectedTab = .edit_game
                                    } label:{
                                        Text("Edit")
                                            .font(
                                                .custom(
                                                    "comfortaa",
                                                    size: geometry.size.width * 0.05
                                                )
                                            )
                                            .fontWeight(Font.Weight.bold)
                                            .foregroundColor(
                                                colorScheme == .light ? .black : .white
                                            )
                                            .padding()
                                            .frame(
                                                maxWidth: .infinity,
                                                maxHeight: geometry.size.height * 0.2
                                            )
                                            .background(gradient)
                                            .cornerRadius(10)
                                            .shadow(radius: 3)
                                    }
                                    .padding(
                                        EdgeInsets(
                                            top: 0,
                                            leading: geometry.size.width * 0.01,
                                            bottom: geometry.size.width * 0.01,
                                            trailing: geometry.size.width * 0.04
                                        )
                                    )
                                    .shadow(
                                        color: .black.opacity(0.5),
                                        radius: 1,
                                        x: 0,
                                        y: 1
                                    )
                                    .shadow(
                                        color: .black.opacity(0.5),
                                        radius: 1,
                                        x: 0,
                                        y: -1
                                    ) // subtle top glow
                                    
                                }
                            }
                                
                            Button {
                                selectedTab = .game_summary
                            } label:{
                                Text("Summary/Leave")
                                    .font(
                                        .custom(
                                            "comfortaa",
                                            size: geometry.size.width * 0.05
                                        )
                                    )
                                    .fontWeight(Font.Weight.bold)
                                    .foregroundColor(
                                        colorScheme == .light ? .black : .white
                                    )
                                    .padding()
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: geometry.size.height * 0.2
                                    )
                                    .background(gradient)
                                    .cornerRadius(10)
                                    
                            }
                            .padding(
                                EdgeInsets(
                                    top: 0,
                                    leading: geometry.size.width * 0.04,
                                    bottom: geometry.size.width * 0.01,
                                    trailing: geometry.size.width * 0.04
                                )
                            )
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 1,
                                x: 0,
                                y: 1
                            )
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 1,
                                x: 0,
                                y: -1
                            ) // subtle top glow
                                
                            
                        }
                        .background(.offBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, geometry.size.height * 0.03)
                        
                        
                    }
                    .shadow(
                        color: .black.opacity(0.9),
                        radius: 1,
                        x: 0,
                        y: -1
                    ) // subtle top glow
                        
                        
                    

                }
                .frame(maxWidth: .infinity)
            }
            .background(.colorScheme)
            .edgesIgnoringSafeArea(.vertical)
            .onChange(of: show_buy_in_sheet) { old, new in
                if !show_buy_in_sheet && auth_view_model.user?.uid != "nyyEs88t04eGTXlIKYYZqdXofib2" && auth_view_model.isTrackingAccessAvailable() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        interstital_ads_manager.displayInterstitialAd()
                    }
                    
                }
            }
            .onAppear {
                if game_view_model.game.title == ""  {
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
                            }
                        }
                        
                    
                }
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                    if auth_view_model.user?.uid == game_view_model.game.host_id{
                        is_host = true
                    }
                }
            }
            
            .overlay {
                if copied_to_clipboard {
                    Text("Copied to Clipboard")
                        .font(
                            .custom(
                                "comfortaa",
                                size: geometry.size.width * 0.04
                            )
                        )  // Dynamic font size
                        .foregroundStyle(
                            colorScheme == .light ? .black : .white
                        )
                        .padding()
                        .background(gradient)
                        .clipShape(Capsule())
                        .shadow(
                            color: .black.opacity(0.5),
                            radius: 1,
                            x: 0,
                            y: 1
                        )
                        .shadow(
                            color: .black.opacity(0.5),
                            radius: 1,
                            x: 0,
                            y: -1
                        ) // subtle top glow
                        .transition(.move(edge: .bottom))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, geometry.size.height * 0.05)
                }
            }
            
        }
        .sheet(isPresented: $show_buy_in_sheet) {
            Buy_in_Sheet_View()
                .environmentObject(game_view_model)
                .environmentObject(auth_view_model)
                .environmentObject(interstital_ads_manager)
                .presentationDetents([.fraction(0.35)])
                    
        }
        
    }
}

struct In_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            In_Game_View(selectedTab: .constant(.dashboard))
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
                .preferredColorScheme(.dark)
            
            In_Game_View(selectedTab: .constant(.dashboard))
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
        }
    }
}
