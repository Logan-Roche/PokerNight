import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FinanceKit
import FirebaseAuth

struct ContentView: View {
    //@EnvironmentObject var databaseManager: Database_Manager    
    
    let background_color = Color(red: 23 / 255, green: 23 / 255, blue: 25 / 255)
    let auth = Auth.auth()
    
    var body: some View {
        VStack{
            Text("Hello")
                .foregroundStyle(.white)
            Button("Log Out")
            {
                do {
                    try auth.signOut()
                } catch let sign_our_error {
                    print(sign_our_error)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background_color)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.environmentObject(Database_Manager())
    }
}
