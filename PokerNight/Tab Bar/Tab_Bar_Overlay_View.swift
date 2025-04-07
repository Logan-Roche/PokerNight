import SwiftUI

struct Tab_Bar_Overlay_View: View {
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink(destination: Join_Game_View()){
                    Text("Join Game")
                        .font(.custom("Roboto", size: 17))
                        .fontWeight(Font.Weight.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(gradient)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(
                    EdgeInsets(top: 30, leading: 35, bottom: 0, trailing: 35)
                )

                
                
                Button {
                    selectedTab = .start_game
                    dismiss()
                } label:{
                    Text("Start Game")
                        .font(.custom("Roboto", size: 17))
                        .fontWeight(Font.Weight.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(gradient)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(
                    EdgeInsets(top: 10, leading: 35, bottom: 15, trailing: 35)
                )
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    VStack (alignment: .center, spacing: 4) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit( )
                            .frame(width: 15, height:15)
                            .rotationEffect(.init(degrees: 45))
                            .foregroundStyle(
                                colorScheme == .light ? Color.black : Color.white
                            )
                        
                    }
                    .clipShape(Capsule())
                }
                .tint(.gradientColorRight)
                .frame(width: 68, height: 40)
                .background(gradient)
                .clipShape(Capsule())
                .padding(.bottom)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.offBlack)
        }
    }

}

struct Tab_Bar_Overlay_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Tab_Bar_Overlay_View(selectedTab: .constant(.profile))
                .preferredColorScheme(.dark)
            Tab_Bar_Overlay_View(selectedTab: .constant(.profile))
        }
    }
}
