import SwiftUI
import FirebaseAuth

struct Account_Deletion_Confirmation_View: View {
    @Environment(\.colorScheme) var colorScheme
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    
    @EnvironmentObject var auth_view_model: Authentication_View_Model

    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                VStack{
                    Text("Are you sure you want to delete your account?")
                        .font(
                            .custom(
                                "comfortaa",
                                size: geometry.size.width * 0.073
                            )
                        )
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: geometry.size.height * 0.01,
                                trailing: 0
                            )
                        )
                    
                                
                    Button {
                        
                        auth_view_model.deleteUserAccount()
                        dismiss()
                        
                    } label:{
                        Text("Confirm")
                            .font(
                                .custom(
                                    "comfortaa",
                                    size: geometry.size.width * 0.05
                                )
                            )
                            .fontWeight(Font.Weight.bold)
                            .foregroundColor(
                                colorScheme == .light ? .black : .white
                            )
                            .padding()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: geometry.size.height * 0.3
                            )
                            .background(gradient)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: geometry.size.width * 0.04,
                            bottom: geometry.size.width * 0.01,
                            trailing: geometry.size.width * 0.04
                        )
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorScheme)
        }
    }
}

struct Account_Deletion_Confirmation_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Account_Deletion_Confirmation_View()
                .environmentObject(Authentication_View_Model())
                .preferredColorScheme(.dark)
            
            Account_Deletion_Confirmation_View()
                .environmentObject(Authentication_View_Model())
        }
    }
}
