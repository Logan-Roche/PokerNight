import SwiftUI
import FirebaseCore
import FirebaseFirestore


struct ContentView: View {
    @EnvironmentObject var databaseManager: Database_Manager
    let background_color = Color(red: 23 / 255, green: 23 / 255, blue: 25 / 255)
    
    var body: some View {
        VStack{
            Text("Hello")
                .foregroundStyle(.white)
            List(databaseManager.data, id: \.id) { item in
                Text("\(item.id)")
            }
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background_color)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Database_Manager())
    }
}
