//
//  Authentication_View_Model.swift
//  PokerNight
//
//  Created by Logan Roche on 3/2/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore

// For Sign in with Apple
import AuthenticationServices
import CryptoKit

// For Sing in with Google
import GoogleSignIn
import GoogleSignInSwift

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
        verifySignInWithAppleAuthenticationState()
        
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

// MARK: - Apple Authentication


extension Authentication_View_Model {
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        current_nonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            error_message = failure.localizedDescription
        }
        else if case .success(let authorization) = result {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = current_nonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetdch identify token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.appleCredential( withIDToken: idTokenString,
                                                                rawNonce: nonce,
                                                                fullName: appleIDCredential.fullName)
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        await updateDisplayName(for: result.user, with: appleIDCredential)
                    }
                    catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
                
            }
        }
    }
    
    func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // current user is non-empty, don't overwrite it
        }
        else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.displayName()
            do {
                try await changeRequest.commitChanges()
                self.display_name = Auth.auth().currentUser?.displayName ?? ""
            }
            catch {
                print("Unable to update the user's displayname: \(error.localizedDescription)")
                error_message = error.localizedDescription
            }
        }
    }
    
    func verifySignInWithAppleAuthenticationState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                do {
                    let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                    switch credentialState {
                    case .authorized:
                        break // The Apple ID credential is valid.
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        self.Sign_Out()
                    default:
                        break
                    }
                }
                catch {
                }
            }
        }
    }
    
}

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap( {$0})
            .joined(separator: " ")
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}


// MARK: - Google Authentication


enum AuthenticaionError: Error {
    case token_error(message: String)
}

extension Authentication_View_Model {
    func Sign_In_With_Google() async -> Bool {
        guard let client_id = FirebaseApp.app()?.options.clientID else {
            fatalError("No Client ID found in firebaes Config")
        }
        let config = GIDConfiguration(clientID: client_id)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let window_scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await window_scene.windows.first,
              let root_view_controller = await window.rootViewController else {
            print("There is no root view controller")
            return false
        }
        
        do {
            let user_authentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: root_view_controller)
            let user = user_authentication.user
            guard let id_token = user.idToken else {
                throw AuthenticaionError.token_error(message: "No ID Token Found")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: id_token.tokenString, accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            
            return true
        }
        catch {
            print(error.localizedDescription)
            error_message = error.localizedDescription
            return false
        }
        
        
        
    }
}

