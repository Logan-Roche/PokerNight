import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FinanceKit
import FirebaseAuth

struct ContentView: View {
    //@EnvironmentObject var databaseManager: Database_Manager
    @State var selectedTab: Tabs = .contacts
    
    
    var body: some View {
        
        VStack{
            Text("hello")
            
            Spacer()
            
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
