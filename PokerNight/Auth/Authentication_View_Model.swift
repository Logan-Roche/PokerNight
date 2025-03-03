//
//  Authentication_View_Model.swift
//  PokerNight
//
//  Created by Logan Roche on 3/2/25.
//

import Foundation
import FirebaseAuth

// For Sign in with Apple
import AuthenticationServices
import CryptoKit

enum Authentication_State {
  case unauthenticated
  case authenticating
  case authenticated
}

enum Authentication_Flow {
  case login
  case signUp
}

class Authentication_View_Model: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirm_password = ""
    
    @Published var flow: Authentication_Flow = .login
    
    @Published var is_valid = false
    @Published var authentication_state: Authentication_State = .unauthenticated
    @Published var error_message = ""
    @Published var user: User?
    @Published var display_name = ""
    
    private var current_nonce: String?
    
    init() {
        registerAuthStateHandler()
        //verifySignInWithAppleAuthenticationState()

        $flow
          .combineLatest($email, $password, $confirm_password)
          .map { flow, email, password, confirmPassword in
            flow == .login
            ? !(email.isEmpty || password.isEmpty)
            : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
          }
          .assign(to: &$is_valid)
      }

      private var authStateHandler: AuthStateDidChangeListenerHandle?

      func registerAuthStateHandler() {
        if authStateHandler == nil {
          authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
            self.authentication_state = user == nil ? .unauthenticated : .authenticated
              self.display_name = user?.displayName ?? user?.email ?? ""
          }
        }
      }

      func switchFlow() {
        flow = flow == .login ? .signUp : .login
        error_message = ""
      }

      private func wait() async {
        do {
          print("Wait")
          try await Task.sleep(nanoseconds: 1_000_000_000)
          print("Done")
        }
        catch {
          print(error.localizedDescription)
        }
      }

      func reset() {
        flow = .login
        email = ""
        password = ""
        confirm_password = ""
      }
    }




// MARK: - Email and Password Authentication

extension Authentication_View_Model {
  func Sign_In_With_Email_Password() async -> Bool {
    authentication_state = .authenticating
    do {
      try await Auth.auth().signIn(withEmail: self.email, password: self.password)
      return true
    }
    catch  {
      print(error)
      error_message = error.localizedDescription
      authentication_state = .unauthenticated
      return false
    }
  }

  func Sign_Up_With_Email_Password() async -> Bool {
    authentication_state = .authenticating
    do  {
      try await Auth.auth().createUser(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      error_message = error.localizedDescription
      authentication_state = .unauthenticated
      return false
    }
  }

  func Sign_Out() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      error_message = error.localizedDescription
    }
  }

  func Delete_Account() async -> Bool {
//    do {
//      try await user?.delete()
      return true
//    }
//    catch {
//      errorMessage = error.localizedDescription
//      return false
//    }
  }
}
