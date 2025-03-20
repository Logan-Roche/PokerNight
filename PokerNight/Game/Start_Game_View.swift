//
//  Start_Game_View.swift
//  PokerNight
//
//  Created by Logan Roche on 3/19/25.
//

import SwiftUI

struct Start_Game_View: View {
    var body: some View {
        VStack {
            Text("Start Game")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.colorScheme)
        
    }
}

struct Start_Game_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Start_Game_View()
                .preferredColorScheme(.dark)
            Start_Game_View()
        }
    }
}
