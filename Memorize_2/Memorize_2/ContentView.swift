//
//  ContentView.swift
//  Memorize_2
//
//  Created by oeng hokleng on 5/5/22.
//

import SwiftUI

struct ContentView: View {
    
    var viewModel: EmojiMemoryGame
    @State var isFaceUp: Bool = true
    
    var body: some View {
        
        HStack{
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture{
                    self.viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(Color.orange)
        .font(Font.largeTitle)
        
            
    }
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(.white)
                RoundedRectangle(cornerRadius: 10.0)
                     .stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
       }
    }
}
























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
