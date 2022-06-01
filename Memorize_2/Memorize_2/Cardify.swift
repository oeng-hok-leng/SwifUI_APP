//
//  Cardify.swift
//  Memorize_2
//
//  Created by oeng hokleng on 1/6/22.
//

import SwiftUI


struct Cardify: ViewModifier {
    var isFaceUp: Bool
    func body(content: Content) -> some View {
        ZStack{
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(.white)
                RoundedRectangle(cornerRadius:  cornerRadius)
                    .stroke(lineWidth:  edgeLineWidth)
                content
            } else {
                    RoundedRectangle(cornerRadius:  cornerRadius).fill()
            }
        }
        
    }
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3.0
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
