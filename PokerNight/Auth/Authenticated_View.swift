
import SwiftUI
import AuthenticationServices

// see https://michael-ginn.medium.com/creating-optional-viewbuilder-parameters-in-swiftui-views-a0d4e3e1a0ae
extension Authenticated_View where Unauthenticated == EmptyView {
  init(@ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = nil
    self.content = content
  }
}

struct Authenticated_View<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
  @StateObject private var viewModel = Authentication_View_Model()
  @State private var presentingLoginScreen = false
//  @State private var presentingProfileScreen = false

  var unauthenticated: Unauthenticated?
  @ViewBuilder var content: () -> Content

  public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = unauthenticated
    self.content = content
  }

  public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = unauthenticated()
    self.content = content
  }


  let background_color = Color(red: 23 / 255, green: 23 / 255, blue: 25 / 255)
  var body: some View {
    switch viewModel.authentication_state {
    case .unauthenticated, .authenticating:
      VStack {
        if let unauthenticated = unauthenticated {
          unauthenticated
        }
          
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
              
              VStack {
                  Button(action: {
                      viewModel.reset()
                      presentingLoginScreen.toggle()
                  }) {
                      Text("Log-In / Register")
                          .font(.custom("Roboto", size: 17))
                          .fontWeight(Font.Weight.bold)
                          .foregroundColor(.white)
                          .padding()
                          .frame(maxWidth: .infinity)
                          .background(.black)
                          .cornerRadius(10)
                          .shadow(radius: 3)
                  }
                  .padding(.horizontal, 35)
                  .padding(.top, 30)
              
              }
              .frame(maxWidth: .infinity, alignment: .bottom)
              .background(background_color)

              
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Image("Log-Out Background Image")
              .resizable()
              .scaledToFill()
              .ignoresSafeArea())
          
      }
      .sheet(isPresented: $presentingLoginScreen) {
        Authentication_View()
          .environmentObject(viewModel)
      }
    case .authenticated:
      VStack {
        content()
          .environmentObject(viewModel)
//        Text("You're logged in as \(viewModel.displayName).")
//        Button("Tap here to view your profile") {
//          presentingProfileScreen.toggle()
//        }
      }
      .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { event in
        viewModel.Sign_Out()
        if let userInfo = event.userInfo, let info = userInfo["info"] {
          print(info)
        }
      }
//      .sheet(isPresented: $presentingProfileScreen) {
//        NavigationView {
//          UserProfileView()
//            .environmentObject(viewModel)
//        }
//      }
    }
  }
}

struct AuthenticatedView_Previews: PreviewProvider {
  static var previews: some View {
    Authenticated_View {
      ContentView()
    }
  }
}
