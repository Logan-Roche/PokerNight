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
    VStack {
      Image("Login")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(minHeight: 300, maxHeight: 400)
      Text("Login")
            .font(.custom("Comfortaa", size: 40))
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)

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
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
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
      .frame(maxWidth: .infinity, minHeight: 50)
      .cornerRadius(8)
        
        Button(action: Sign_In_With_Google) {
            Text("       Sign in with Google")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .font(.system(size: 19))
                .fontWeight(.medium)
                .background(alignment: .leading) {
                    Image("Google")
                        .resizable()
                        .frame(width: 17, height:17,  alignment: .center)
                        .scaledToFit()
                        .offset(x: 85)

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
      .padding([.top, .bottom], 50)

    }
    .listStyle(.plain)
    .padding()
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
