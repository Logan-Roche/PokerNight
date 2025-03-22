import SwiftUI

struct Join_Game_View: View {
    
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
     
    
    var body: some View {
        VStack {
            Text("Join Game")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.offBlack)
        .navigationBarBackButtonHidden(true)
        
        
    }
    
}

struct Join_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Join_Game_View()
                .preferredColorScheme(.dark)
                .environmentObject(Authentication_View_Model())
            Join_Game_View()
                .environmentObject(Authentication_View_Model())
        }
    }
}
