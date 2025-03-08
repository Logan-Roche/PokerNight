import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FinanceKit
import FirebaseAuth

struct ContentView: View {
    //@EnvironmentObject var databaseManager: Database_Manager
    @State var selectedTab: Tabs = .dashboard
    
    
    var body: some View {
        
        VStack{
            
            
            Spacer()a
            
            if selectedTab == .dashboard {
                Dashboard_View()
            } else {
                Profile_View()
            }
            Custom_Tab_Bar(selectedTab: $selectedTab)
            
        }
        .background(.colorScheme)
        
        
        
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
