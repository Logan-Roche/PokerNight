//
// LoginView.swift
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
      
//      SignInWithAppleButton(.signIn) { request in
//        viewModel.handleSignInWithAppleRequest(request)
//      } onCompletion: { result in
//        viewModel.handleSignInWithAppleCompletion(result)
//      }
//      .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
//      .frame(maxWidth: .infinity, minHeight: 50)
//      .cornerRadius(8)

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
        Log_In_View()
        .preferredColorScheme(.dark)
    }
    .environmentObject(Authentication_View_Model())
  }
}
