import SwiftUI

struct Single_Game_View: View {
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    @Binding var selected_game: Game
    
    @State var total_buy_in = 0.0
    @State var total_buy_out = 0.0
    @State var chip_error = 0.0
    @State var chip_error_divided = 0.0
    @State var eligibleUserCount = 0
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
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
                        .shadow(radius: 5)
                        .offset(
                            y: -geometry.size.height * 0.45
                        )
                    VStack {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .frame(width: geometry.size.width * 0.13)
                                .font(.system(size: geometry.size.width * 0.06))
                                .onTapGesture {pGesture in
                                    selectedTab = .all_game_view
                                }
                            Spacer()
                        }
                        Text(selected_game.title)
                            .foregroundStyle(
                                colorScheme == .light ? .black : .white
                            )
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.08
                                )
                            )
                            .offset(y: -geometry.size.height * 0.01)
                            
                    }
                    
                }
                .frame(maxHeight: geometry.size.height * 0.05)
                .padding(.bottom, geometry.size.height * 0.06)
                
                VStack {
                    LazyVGrid(
                        columns: columns,
                        spacing: geometry.size.width * 0.5
                    ) {
                        StatCard(
                            title: "TOTAL BUY-IN",
                            value: "\(total_buy_in < 0 ? "-" : "")$\(String(format: "%.2f", abs(total_buy_in)))"
                        )
                        StatCard(
                            title: "TOTAL BUY-OUT",
                            value: "\(total_buy_out < 0 ? "-" : "")$\(String(format: "%.2f", abs(total_buy_out)))"
                        )
                        StatCard(
                            title: "CHIP ERROR",
                            value:"\(chip_error < 0 ? "-" : "")$\(String(format: "%.2f", abs(chip_error)))"
                        )
                        StatCard(
                            title: "CHIP ERROR DIVIDED",
                            value: "\(chip_error_divided < 0 ? "-" : "")$\(String(format: "%.2f", abs(chip_error_divided)))"
                        )
                    }
                    .padding()
                    .padding(.bottom, geometry.size.height * 0.24)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Pay Out Summary")
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
                                    Text("Buy Out")
                                    Text("Adjusted Buy Out")
                                }
                                .font(
                                    .custom(
                                        "comfortaa",
                                        size: geometry.size.width * 0.037
                                    )
                                )
                                .foregroundStyle(
                                    colorScheme == .light ? .black : .white
                                )
                                
                                Divider()
                                
                                // Item Rows
                                ForEach(
                                    Array(selected_game.users.keys).sorted(),
                                    id: \.self
                                ) { key in
                                    //ForEach(Array(sampleUsers.keys).sorted(), id: \.self) { key in
                                    
                                    if let stats = selected_game.users[key] {
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
                                                "$\(stats.buy_out,specifier: "%.2f")"
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
                                                "\(((stats.buy_out > 0.00001 ? stats.buy_out + chip_error_divided : stats.buy_out) < 0 ? "-" : ""))$\(String(format: "%.2f", abs(stats.buy_out > 0.00001 ? stats.buy_out + chip_error_divided : stats.buy_out)))"
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
                                        selected_game.transactions.indices,
                                        id: \.self
                                    ) { index in
                                        let transaction = selected_game.transactions[index]
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
                                if let lastTransaction = selected_game.transactions.last {
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
                                of: selected_game.transactions.count
                            ) {
                                _,
                                _ in
                                if let lastTransaction = selected_game.transactions.last {
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

                    
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(.colorScheme)
        .onAppear() {
            total_buy_in = selected_game.users.values
                .reduce(0.0) { partialSum, userStats in
                    partialSum + userStats.buy_in
                }
            total_buy_out = selected_game.users.values
                .reduce(0.0) { partialSum, userStats in
                    partialSum + userStats.buy_out
                }
            chip_error = total_buy_in - total_buy_out
            chip_error_divided = chip_error / (
                Double(selected_game.users.values.filter { $0.buy_out > 0.001 }.count) != 0 ? Double(
                    selected_game.users.values.filter { $0.buy_out > 0.001
                    }.count) : 1.0
            )
            
            
        }
    }
}
    
    
struct Single_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Single_Game_View(
                selectedTab: .constant(.buy_out),
                selected_game: 
                        .constant(
                            Game(
                                date: Date(),
                                title: "hello",
                                host_id: "",
                                sb_bb: "",
                                is_active: false,
                                chip_error_divided: 0.0,
                                users: [:]
                            )
                        )
            )
            .environmentObject(Authentication_View_Model())
            .environmentObject(Games_View_Model())
            .preferredColorScheme(.dark)
            Single_Game_View(
                selectedTab: .constant(.buy_out),
                selected_game: 
                        .constant(
                            Game(
                                date: Date(),
                                title: "",
                                host_id: "",
                                sb_bb: "",
                                is_active: false,
                                chip_error_divided: 0.0,
                                users: [:]
                            )
                        )
            )
            .environmentObject(Authentication_View_Model())
            .environmentObject(Games_View_Model())
        }
    }
}
