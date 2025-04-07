import SwiftUI

struct Join_Game_View: View {
    
    @EnvironmentObject var auth_view_model: Authentication_View_Model  // Use shared instance
    @EnvironmentObject var game_view_model: Games_View_Model
    @Environment(\.colorScheme) var colorScheme
    
    @State private var amount: String = ""
     
    
    var body: some View {
        VStack {
            TextField("Enter Buy Out", text: $amount)
                .submitLabel(.done)
                .padding()
                .background(.offBlack)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            colorScheme == .light ? .gray : .black,
                            lineWidth: 1.5
                        )
                )
                .foregroundColor(.gray)
                .font(.custom("roboto-regular", size: 15))
                .padding(.horizontal)
                //.scrollDismissesKeyboard(.immediately)
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
