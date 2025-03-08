//
// SignupView.swift
// Favourites
//
// Created by Peter Friese on 08.07.2022
// Copyright © 2022 Google LLC.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI
import Combine
import AuthenticationServices

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct Sign_Up_View: View {
    @EnvironmentObject var viewModel: Authentication_View_Model
    @Environment(\.dismiss) var dismiss
    
    
    @FocusState private var focus: FocusableField?
    
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.Sign_Up_With_Email_Password() == true {
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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Image("SignUp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            Text("Sign up")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("Comfortaa", size: 40))
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .font(.custom("Roboto", size: 15))
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
                    .submitLabel(.next)
                    .font(.custom("Roboto", size: 15))
                    .fontWeight(.bold)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Confirm password", text: $viewModel.confirm_password)
                    .focused($focus, equals: .confirmPassword)
                    .font(.custom("Roboto", size: 15))
                    .fontWeight(.bold)
                    .submitLabel(.go)
                    .onSubmit {
                        signUpWithEmailPassword()
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
            
            Button(action: signUpWithEmailPassword) {
                if viewModel.authentication_state != .authenticating {
                    Text("Sign up")
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
            
            SignInWithAppleButton(.signUp) { request in
                viewModel.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                viewModel.handleSignInWithAppleCompletion(result)
            }
            .signInWithAppleButtonStyle(.black)
            .frame(maxWidth: .infinity, minHeight: 50)
            .cornerRadius(8)
            
            Button(action: Sign_In_With_Google) {
                Text("       Sign up with Google")
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
                            .offset(x: 82)
                        
                    }
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            
            
            HStack {
                Text("Already have an account?")
                Button(action: { viewModel.switchFlow() }) {
                    Text("Log in")
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

struct Sign_Up_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Sign_Up_View()
                .preferredColorScheme(.dark)
            Sign_Up_View()
        }
        .environmentObject(Authentication_View_Model())
    }
}
