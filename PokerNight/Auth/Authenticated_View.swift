
import SwiftUI
import AuthenticationServices

extension Authenticated_View where Unauthenticated == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = nil
        self.content = content
    }
}

struct Authenticated_View<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    @StateObject private var viewModel = Authentication_View_Model()
    @State private var presentingLoginScreen = false
    @State public var presentingProfileScreen = false
    
    
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
    
    let gradient = LinearGradient(colors: [.gradientColorLeft, .gradientColorRight], startPoint: .top, endPoint: .topTrailing)
    @Environment(\.colorScheme) var colorScheme
    
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
                            .shadow(color: .black, radius: 10, x: 1, y: 1)
                        
                    }
                    .padding(.top, 275)
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            viewModel.reset()
                            presentingLoginScreen.toggle()
                        }) {
                            Text("Sign In / Sign Up")
                                .font(.custom("Roboto", size: 17))
                                .fontWeight(Font.Weight.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(gradient)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                        .padding(EdgeInsets(top: 30, leading: 35, bottom: 15, trailing: 35))
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .background(.colorScheme)
                    
                    
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
            }
            .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { event in
                viewModel.Sign_Out()
                if let userInfo = event.userInfo, let info = userInfo["info"] {
                    print(info)
                }
            }
            .sheet(isPresented: $presentingProfileScreen) {
                NavigationView {
                    User_Profile_View()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

struct AuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            Authenticated_View {
                ContentView()
            }
            .preferredColorScheme(.dark)
            Authenticated_View {
                ContentView()
            }
            
        }
    }
}

