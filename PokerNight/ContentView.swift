import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FinanceKit
import FirebaseAuth

struct ContentView: View {
    //@EnvironmentObject var databaseManager: Database_Manager
    @State var selectedTab: Tabs = .dashboard
    @State var start_game_join_game_sheet: Bool = false
    @State var start_game_view: Bool = false
    
    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                if selectedTab == .dashboard {
                    Dashboard_View()
                } else if selectedTab == .profile {
                    Profile_View()
                } else {
                    Start_Game_View()
                }
                
                Custom_Tab_Bar(selectedTab: $selectedTab, start_game_join_game_sheet: $start_game_join_game_sheet)
                    .sheet(isPresented: $start_game_join_game_sheet) {
                        print("Sheet dismissed!")
                    } content: {
                        Tab_Bar_Overlay_View(selectedTab: $selectedTab)
                            .presentationDetents([.fraction(0.30)])
                    }
                
            }
            .background(.colorScheme)
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
