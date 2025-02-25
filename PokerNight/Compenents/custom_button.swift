//
//  custom_button.swift
//  PokerNight
//
//  Created by Logan Roche on 2/24/25.
//

import SwiftUI

struct custom_button: View {
    var title: String
    var backgroundColor: Color = Color.blue
    var textColor: Color = Color.white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
    }
}
