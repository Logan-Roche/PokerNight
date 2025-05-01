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
        host_id: "" ,
        sb_bb: "N/A",
        is_active: false,
        chip_error_divided: 0.0,
        users: [:],
        user_ids: [],
        transactions: []
    )
    
    
    
    
    @EnvironmentObject var game_view_model: Games_View_Model  // Use shared instance
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
    @EnvironmentObject var interstital_ads_manager: InterstitialAdsManager

    var body: some View {
        NavigationStack {
            VStack {
                if selectedTab == .dashboard {
                    Dashboard_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .profile {
                    Profile_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                        .environmentObject(interstital_ads_manager)
                } else if selectedTab == .start_game {
                    Start_Game_View(selectedTab: $selectedTab)
                        .environmentObject(auth_view_model)
                        .environmentObject(game_view_model)
                        .environmentObject(interstital_ads_manager)
                } else if selectedTab == .in_game {
                    In_Game_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                        .environmentObject(interstital_ads_manager)
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
                        .environmentObject(interstital_ads_manager)
                } else if selectedTab == .profile_settings {
                    Profile_Settings_View(selectedTab: $selectedTab)
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .all_game_view {
                    All_Games_View(
                        selectedTab: $selectedTab,
                        selected_game: $selected_game
                    )
                    .environmentObject(game_view_model)
                    .environmentObject(auth_view_model)
                } else if selectedTab == .single_game_view {
                    Single_Game_View(
                        selectedTab: $selectedTab,
                        selected_game: $selected_game
                    )
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
                Tab_Bar_Overlay_View(
                    start_game_join_game_sheet: $start_game_join_game_sheet,
                    selectedTab: $selectedTab
                )
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
            if game_view_model.games.isEmpty && auth_view_model.user != nil {
                
                if let userID = Auth.auth().currentUser?.uid, !userID.isEmpty {
                    game_view_model.fetchAndCalculateUserStats(for: userID)
                }

    
//                game_view_model
//                    .fetchAndCalculateUserStats(for: auth_view_model.user!.uid)
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
