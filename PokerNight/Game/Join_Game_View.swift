import SwiftUI

struct Join_Game_View: View {
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
            Join_Game_View()
        }
    }
}
