import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FinanceKit
import FirebaseAuth

struct ContentView: View {
    @State var selectedTab: Tabs = .dashboard
    @State var start_game_join_game_sheet: Bool = false
    @State var start_game_view: Bool = false
    @State private var isKeyboardVisible = false
    @State private var delayedShowTabBar = true
    
    

    
    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                if selectedTab == .dashboard {
                    Dashboard_View()
                } else if selectedTab == .profile {
                    Profile_View()
                } else if selectedTab == .start_game{
                    Start_Game_View(selectedTab: $selectedTab)
                } else if selectedTab == .in_game{
                    In_Game_View()
                }
                
                if !isKeyboardVisible && delayedShowTabBar {
                    Custom_Tab_Bar(selectedTab: $selectedTab, start_game_join_game_sheet: $start_game_join_game_sheet)
                        .transition(.move(edge: .bottom))   // Add transition animation
                        .animation(.easeInOut, value: isKeyboardVisible)
                        .sheet(isPresented: $start_game_join_game_sheet) {
                        } content: {
                            Tab_Bar_Overlay_View(selectedTab: $selectedTab)
                                .presentationDetents([.fraction(0.30)])
                        }
                }
                
                
            }
            .background(.colorScheme)
        }
        .onAppear {
                    // Detect keyboard appearance and dismissal
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                        isKeyboardVisible = true
                        delayedShowTabBar = false // Hide tab bar immediately when keyboard appears
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        isKeyboardVisible = false
                        
                        // Add a delay before showing the tab bar after the keyboard hides
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
                .preferredColorScheme(.dark)
            ContentView()
        }
        
        //.environmentObject(Database_Manager())
    }
}
