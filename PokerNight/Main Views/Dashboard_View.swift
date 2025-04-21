import SwiftUI
import Charts
import FirebaseAuth

struct Dashboard_View: View {
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    
    @State private var rawSelectedDate: Date?
    @State private var selected_time_unit: Int = 14
    
    
    var selectedGame: Game?  {
        guard let rawSelectedDate else { return nil }
        return game_view_model.games.first {
            Calendar.current
                .isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .day)
        }
        
    }
    
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
                        Image("Icon")
                            .resizable()
                            .frame(
                                width: geometry.size.width * 0.12,
                                height: geometry.size.width * 0.12
                            )
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                        
                        if let url = auth_view_model.user?.photoURL {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(
                                width: geometry.size.width * 0.12,
                                height: geometry.size.width * 0.12
                            )
                            .clipShape(Circle())
                            .padding()
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(
                                    width: geometry.size.width * 0.12,
                                    height: geometry.size.width * 0.12
                                )
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .frame(alignment: .leading)
                    
                    
                    ZStack {
                        Rectangle()
                            .fill(gradient)
                            .frame(
                                height: geometry.size.height * 0.2
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: geometry.size.width * 0.07
                                )
                            )
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 3,
                                x: 0,
                                y: 3
                            )
                            .padding(.horizontal, geometry.size.width * 0.03)
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
                            )
                        
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
                    
                    VStack {
                        Text("Net History")
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
                        
                        Chart {
                            let netValues = game_view_model.games.map {
                                $0
                                    .users[auth_view_model.user!.uid]!.buy_out != 0.0 ? $0
                                    .users[auth_view_model.user!.uid]!.net + $0.chip_error_divided : $0
                                    .users[auth_view_model.user!.uid]!.net
                            }
                            let minNet = netValues.min() ?? 0
                            let maxNet = netValues.max() ?? 0
                            let zeroPosition: CGFloat = (maxNet != minNet)
                            ? CGFloat((maxNet - 0) / (maxNet - minNet))
                            : 0.5
                            let adjustedZeroPosition = max(
                                zeroPosition - 0.03,
                                0.0
                            )
                            

                            
                            ForEach(
                                game_view_model.games
                                    .sorted(by: { $0.date < $1.date }),
                                id: \.id
                            ) { game in
                                AreaMark(
                                    x: .value("Date", game.date, unit: .day),
                                    y: 
                                            .value(
                                                "Net",
                                                (
                                                    game
                                                        .users[auth_view_model.user!.uid]!.buy_out != 0.0 ? game
                                                        .users[auth_view_model.user!.uid]!.net + game.chip_error_divided : game
                                                        .users[auth_view_model.user!.uid]!.net
                                                )
                                            )
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(
stops: [
    .init(
        color: .gradientColorLeft,
        location: 0.0
    ),
    .init(color: .offBlack, location: adjustedZeroPosition),
    .init(color: .gradientColorRight, location: 1.0)
]
                                        ),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .opacity(0.7)
                                )
                                LineMark(
                                    x: .value("Date", game.date, unit: .day),
                                    y: 
                                            .value(
                                                "Net",
                                                game
                                                    .users[auth_view_model.user!.uid]!.buy_out != 0.0 ? game
                                                    .users[auth_view_model.user!.uid]!.net + game.chip_error_divided : game
                                                    .users[auth_view_model.user!.uid]!.net
                                            )
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    .linearGradient(
                                        colors: [.gradientColorLeft],
                                        startPoint: .bottom, endPoint: .top
                                    )
                                )
                                .lineStyle(
                                    StrokeStyle(lineWidth: 4, lineCap: .round)
                                )
                                .alignsMarkStylesWithPlotArea()
                                .symbol(Circle())
                                .symbolSize(100)
                                
                                
                                .alignsMarkStylesWithPlotArea()
                            }
                            
                            if let selectedGame {
                                RuleMark(
                                    x:
                                            .value(
                                                "Date",
                                                selectedGame.date,
                                                unit: .day
                                            )
                                )
                                .foregroundStyle(.gradientColorLeft)
                                .annotation(
                                    position: .top,
                                    overflowResolution: .init(
                                        x: .fit(to: .automatic),
                                        y: .fit(to: .automatic)
                                    )
                                ) {
                                    VStack{
                                        Text(selectedGame.date
                                            .formatted(
                                                date: .abbreviated,
                                                time: .omitted
                                            )
                                        )
                                        .font(
                                            .custom(
                                                "comfortaa",
                                                size: geometry.size.width * 0.04
                                            )
                                        )
                                        .padding(
                                            .bottom,
                                            geometry.size.height * 0.01
                                        )
                        
                                            
                                        Text(
                                            "\( (selectedGame.users[auth_view_model.user!.uid]!.buy_out != 0.0 ? selectedGame.users[auth_view_model.user!.uid]!.net + selectedGame.chip_error_divided : selectedGame.users[auth_view_model.user!.uid]!.net) >= 0 ? "+" : "-")$\(String(format: "%.2f", abs(selectedGame.users[auth_view_model.user!.uid]!.buy_out != 0.0 ? selectedGame.users[auth_view_model.user!.uid]!.net + selectedGame.chip_error_divided : selectedGame.users[auth_view_model.user!.uid]!.net)))"
                                        )
                                        .font(
                                            .custom(
                                                "comfortaa",
                                                size: geometry.size.width * 0.04
                                            )
                                        )


                                    }
                                    .frame(width: geometry.size.width * 0.35)
                                    .padding(geometry.size.width * 0.02)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(gradient)
                                    )
                                }
                                
                            }
                            
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartScrollPosition(initialX: Date())
                        .chartXVisibleDomain(
                            length: 3600 * 24 * selected_time_unit
                        )
                        .chartXSelection(value: $rawSelectedDate)
                        .frame(
                            width: geometry.size.width * 0.9,
                            height: geometry.size.width * 0.9
                        )
                        
                        Picker("Time Scope",selection: $selected_time_unit) {
                            Text("-")
                                .tag(14)
                            Text("+")
                                .tag(50)
                        }
                        .pickerStyle(SegmentedPickerStyle())
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
                    )
                    
                    
                    VStack {
                        Text("Recent Player")
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
                        if let last_game = game_view_model.games.last {
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: [GridItem(.fixed(geometry.size.width * 0.3)), GridItem(.fixed(geometry.size.width * 0.3))], spacing: 24) {
                                    ForEach(Array(last_game.users.keys).sorted(), id: \.self) { userID in
                                        if let user = last_game.users[userID] {
                                            PlayerCard(user: user)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .padding(.bottom)

                    
                }
                .frame(maxWidth: .infinity)
            }
            .background(.colorScheme)
            
        }
    }
    
    struct PlayerCard: View {
        let user: Game.User_Stats
        //let user: User_Stats
        
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
                
                Text(user.name)
                    .font(.custom("comfortaa", size: 12))
                    .frame(width: 100)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(4)
            .cornerRadius(16)
        }
    }
    
}


struct Dashboard_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Dashboard_View(selectedTab: .constant(.dashboard))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
                .preferredColorScheme(.dark)
            Dashboard_View(selectedTab: .constant(.dashboard))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
        }
    }
}
