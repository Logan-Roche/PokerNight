import SwiftUI

struct ContentView: View {
    let background_color = Color(red: 23 / 255, green: 23 / 255, blue: 25 / 255)

    var body: some View {
        VStack {
            HStack  {
                Image("Icon")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .scaledToFit()
                    .padding(.bottom, 15)
                    
                Text("PokerNight")
                    .padding(.leading, 10)
                    .font(.custom("Comfortaa", size: 45))
                    .foregroundStyle(.white)
            }
            .padding(.top, 275)
            
            Spacer()
            
            HStack {
                custom_button(title: "Log-In", backgroundColor: .black, action: {print("Log-In")})
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.bottom, 50)
            .background(background_color)

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("Log-Out Background Image")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
