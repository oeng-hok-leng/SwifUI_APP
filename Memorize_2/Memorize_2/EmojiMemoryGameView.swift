//
//  EmojiMemoryGameView.swift
//  Memorize_2
//
//  Created by oeng hokleng on 5/5/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture{
                self.viewModel.choose(card: card)
//                print("it is clicked")
              
            }
            .padding(5)
        }
        .padding()
        .foregroundColor(Color.orange)
    }
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
    var body: some View {
        
        GeometryReader { geometry in
            self.body(for: geometry.size)
//            Text("\(geometry.size.height)")
        }
    }
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
              ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(1-90), clockwise: true)
                    .padding(5)
                    .opacity(0.4)
                    
                Text(card.content)
                    .font(.system( size: fontSize(for: size ) ) )
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
        
        
        
    }
    // MARK: - Drawing Constants
    

    private let fontScaleFactor: CGFloat = 0.7
    
    
    func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * fontScaleFactor
    }
    
}










struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
            
    }
}
