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
    
    @EnvironmentObject var game_view_model: Games_View_Model  // Use shared instance
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance

    var body: some View {
        NavigationStack {
            VStack {
                if selectedTab == .dashboard {
                    Dashboard_View()
                        .environmentObject(game_view_model)
                        .environmentObject(auth_view_model)
                } else if selectedTab == .profile {
                    Profile_View()
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
                Tab_Bar_Overlay_View(selectedTab: $selectedTab)
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
