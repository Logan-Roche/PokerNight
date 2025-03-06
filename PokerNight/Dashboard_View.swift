//
//  Dashboard_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/5/25.
//

import SwiftUI

struct Dashboard_View: View {
    var body: some View {
        VStack{
            Text("Dashboard")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.colorScheme)
    }
}

struct Dashboard_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Dashboard_View()
                .preferredColorScheme(.dark)
            Dashboard_View()
        }
    }
}
