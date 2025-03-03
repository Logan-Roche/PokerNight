//
// AuthenticationView.swift
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

struct Authentication_View: View {
  @EnvironmentObject var viewModel: Authentication_View_Model

  var body: some View {
    VStack {
      switch viewModel.flow {
      case .login:
        Log_In_View()
          .environmentObject(viewModel)
      case .signUp:
        Sign_Up_View()
          .environmentObject(viewModel)
      }
    }
  }
}

struct Authentication_View_Previews: PreviewProvider {
  static var previews: some View {
    Authentication_View()
          .environmentObject(Authentication_View_Model())
  }
}
