import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FinanceKit
import FirebaseAuth

struct ContentView: View {
    @State var selectedTab: Tabs = .dashboard
    @State var start_game_join_game_sheet: Bool = false
    @State private var isKeyboardVisible = false
    @State private var delayedShowTabBar = true
    
    @State var totalGames: Int = 0
    @State var winRate: Double = 0.0
    @State var averageROI: Double = 0.0
    @State var totalProfit: Double = 0.0
    
    @State var selected_game: Game = Game(
        
        date: Date(),
        title: "",
        total_buy_in: 0,
        total_buy_out: 0,
        player_count: 0,
        host_id: "" ,
        sb_bb: "N/A",
        is_active: false,
        users: [:],
        user_ids: [],
        transactions: []
    )
    
    
    
    
    @EnvironmentObject var game_view_model: Games_View_Model  // Use shared instance
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance

    var body: some View {
        NavigationStack {
            VStack {
                if selectedTab == .dashboard {
                    Dashboard_View(selectedTab: $selectedTab, totalGames: $totalGames)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .profile {
                    Profile_View(selectedTab: $selectedTab, totalGames: $totalGames, winRate: $winRate, averageROI: $averageROI, totalProfit: $totalProfit)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .start_game {
                    Start_Game_View(selectedTab: $selectedTab)
                        .environmentObject(auth_view_model)
                        .environmentObject(game_view_model)
                } else if selectedTab == .in_game {
                    In_Game_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .buy_out {
                    Buy_Out_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .edit_game {
                    Edit_Game_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .game_summary {
                    Game_Sumary_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .profile_settings {
                    Profile_Settings_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .all_game_view {
                    All_Games_View(selectedTab: $selectedTab, selected_game: $selected_game)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .single_game_view {
                    Single_Game_View(selectedTab: $selectedTab, selected_game: $selected_game)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                }

                if !isKeyboardVisible && delayedShowTabBar {
                    Custom_Tab_Bar(
                        selectedTab: $selectedTab,
                        start_game_join_game_sheet: $start_game_join_game_sheet
                    )
                    .environmentObject(game_view_model)
                    .environmentObject(auth_view_model)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isKeyboardVisible)
                    
        
                                        
                                                 
                    }
                }
            .sheet(isPresented: $start_game_join_game_sheet) {
            } content: {
                Tab_Bar_Overlay_View(start_game_join_game_sheet: $start_game_join_game_sheet, selectedTab: $selectedTab)
                    .presentationDetents([.fraction(0.30)])
                    .environmentObject(
                        game_view_model
                    )
            }
            .background(.colorScheme)
        }
        .onAppear {
            // Detect keyboard appearance and dismissal
            NotificationCenter.default
                .addObserver(
                    forName: UIResponder.keyboardWillShowNotification,
                    object: nil,
                    queue: .main
                ) { _ in
                    isKeyboardVisible = true
                    delayedShowTabBar = false
                }
            
            NotificationCenter.default
                .addObserver(
                    forName: UIResponder.keyboardWillHideNotification,
                    object: nil,
                    queue: .main
                ) { _ in
                    isKeyboardVisible = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        delayedShowTabBar = true
                    }
                }
            if game_view_model.games.isEmpty {
                game_view_model.fetchPastGames(for: auth_view_model.user?.uid ?? "") { games in
                    DispatchQueue.main.async {
                        game_view_model.games = games
                        totalGames = game_view_model.games.count
                        
                        var winCount = 0
                        var totalNet: Double = 0.0
                        var totalROI: Double = 0.0
                        
                        
                        for game in game_view_model.games {
                            // Each Game.users is a [String: Any] dictionary of user stats. Get this user's stats:
                            if let userStats = game.users[auth_view_model.user!.uid] {
                                let buyIn = userStats.buy_in
                                let buyOut = userStats.buy_out
                                let net = userStats.net
                                
                                // Win count: increment if net profit is positive
                                if net > 0 {
                                    winCount += 1
                                }
                                // Accumulate total net profit/loss
                                totalNet += net
                                // Calculate ROI for this game if buyIn is not zero
                                if buyIn > 0 {
                                    let roi = (buyOut - buyIn) / buyIn  // ROI for this game (e.g., 0.5 = 50%)&#8203;:contentReference[oaicite:6]{index=6}
                                    totalROI += roi
                                }
                            }
                        }

                        // Compute final metrics
                        winRate = totalGames > 0 ? Double(winCount) / Double(totalGames) : 0.0    // e.g., 0.6 for 60% win rate
                        averageROI = totalGames > 0 ? totalROI / Double(totalGames) : 0.0         // average ROI (as a fraction)
                        totalProfit = totalNet  // total net profit (could be negative for overall loss)
                        
                        print("Total Games: \(totalGames)")
                        print("Win Rate: \(String(format: "%.2f", winRate * 100))%")
                        print("Average ROI: \(String(format: "%.2f", averageROI * 100))%")
                        print("Total Net: \(totalProfit)")

                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
                .preferredColorScheme(.dark)
            
            ContentView()
                .environmentObject(Games_View_Model())
                .environmentObject(Authentication_View_Model())
        }
    }
}
