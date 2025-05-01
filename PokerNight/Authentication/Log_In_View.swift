import SwiftUI
import Combine
import AuthenticationServices

private enum FocusableField: Hashable {
    case email
    case password
}

struct Log_In_View: View {
    @EnvironmentObject var viewModel: Authentication_View_Model
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusableField?
    
    private func Sign_In_With_Email_Password() {
        Task {
            if await viewModel.Sign_In_With_Email_Password() == true {
                dismiss()
            }
        }
    }
    private func Sign_In_With_Google() {
        Task {
            if await viewModel.Sign_In_With_Google() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        GeometryReader {geometry in
            VStack {
                
                Text("Login")
                    .font(.custom("Comfortaa", size: 40))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, geometry.size.height * 0.2)
                
                HStack {
                    Image(systemName: "at")
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .email)
                        .submitLabel(.next)
                        .font(.custom("roboto", size: 15))
                        .fontWeight(.bold)
                        .onSubmit {
                            self.focus = .password
                        }
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $viewModel.password)
                        .focused($focus, equals: .password)
                        .submitLabel(.go)
                        .font(.custom("roboto", size: 15))
                        .fontWeight(.bold)
                        .onSubmit {
                            Sign_In_With_Email_Password()
                        }
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 8)
                
                if !viewModel.error_message.isEmpty {
                    VStack {
                        Text(viewModel.error_message)
                            .foregroundColor(Color(UIColor.systemRed))
                    }
                }
                
                Button(action: Sign_In_With_Email_Password) {
                    if viewModel.authentication_state != .authenticating {
                        Text("Login")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .font(.custom("Confortaa", size: 20))
                            .fontWeight(.bold)
                    }
                    else {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .white)
                            )
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(!viewModel.is_valid)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                
                HStack {
                    VStack { Divider() }
                    Text("or")
                    VStack { Divider() }
                }
                
                SignInWithAppleButton(.signIn) { request in
                    viewModel.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    viewModel.handleSignInWithAppleCompletion(result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 0.08)
                .cornerRadius(8)
                
                Button(action: Sign_In_With_Google) {
                        ZStack(alignment: .leading) {
                            Text("Sign in with Google")
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .font(.system(size: geometry.size.width * 0.05))
                                .fontWeight(.medium)

                            Image("Google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.045, height: geometry.size.width * 0.045)
                                .offset(x: geometry.size.width * 0.15)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                
                
                HStack {
                    Text("Don't have an account yet?")
                    Button(action: { viewModel.switchFlow() }) {
                        Text("Sign up")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 50)
                .padding(.bottom, geometry.size.height * 0.1)
                
                
            }
            .listStyle(.plain)
            .padding()
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct Log_In_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Log_In_View()
                .preferredColorScheme(.dark)
            Log_In_View()
        }
        .environmentObject(Authentication_View_Model())
    }
}
