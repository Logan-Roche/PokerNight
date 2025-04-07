//
//  Custom_Tab_Bar_Button.swift
//  PokerNight
//
//  Created by Logan Roche on 3/7/25.
//

import SwiftUI

struct Custom_Tab_Bar_Button: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var image_name: String
    var is_active: Bool
    
    var body: some View {
        
        GeometryReader { geo in
            
            if is_active {
                Rectangle()
                    .foregroundStyle(.gradientColorRight)
                    .frame(width: geo.size.width / 2, height: 4)
                    .padding(.leading, geo.size.width / 4)
            }
            
            VStack (alignment: .center, spacing: 4) {
                Image(systemName: image_name)
                    .resizable()
                    .scaledToFit( )
                    .frame(width: 24, height:24)
                    .foregroundStyle(
                        colorScheme == .light ? Color.black : Color.white
                    )
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct Custom_Tab_Bar__ButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            Custom_Tab_Bar_Button(image_name: "bubble.left", is_active: true )
                .preferredColorScheme(.dark)
            Custom_Tab_Bar_Button(image_name: "bubble.left", is_active: true )
        }
    }
}
