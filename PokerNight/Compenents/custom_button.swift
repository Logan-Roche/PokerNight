import SwiftUI

struct custom_button: View {
    var title: String
    var backgroundColor: Color = Color.blue
    var textColor: Color = Color.white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Roboto", size: 17))
                .fontWeight(Font.Weight.bold)
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
    }
}
#Preview {
    custom_button(title: "test", backgroundColor: .black, textColor: .white, action: {print("hello")})
}
