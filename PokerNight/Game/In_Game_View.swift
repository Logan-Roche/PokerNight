import SwiftUI
import FirebaseFirestore

struct In_Game_View: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var game_view_model = Games_View_Model()
    
    let gradient = LinearGradient(colors: [.gradientColorLeft, .gradientColorRight], startPoint: .top, endPoint: .topTrailing)
    
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(gradient)
                    .frame(height: 150)
                    .cornerRadius(30)
                    .shadow(radius: 5)

                Text(game_view_model.game.title)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .font(.custom("comfortaa", size: 35))
                    .padding(.top, 45)
            }
            .padding(.bottom, 40)
            
            
            Text("In Game View")
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.colorScheme)
        .edgesIgnoringSafeArea(.all)
        
    }
    
}

struct In_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            In_Game_View()
                .preferredColorScheme(.dark)
            In_Game_View()
        }
    }
}
