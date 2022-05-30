//
//  EmojiMemoryGame.swift
//  Memorize_2
//
//  Created by oeng hokleng on 15/5/22.
//

import SwiftUI


class EmojiMemoryGame:Identifiable {
    private var model: MemoryGame<String> = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻","🎃", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex  in
            return emojis[pairIndex]
        }
    }
   
    
   
    
    
    //MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    //MARK: - Intent(s)
    
    func choose(card:MemoryGame<String>.Card){
        model.choose(card: card)
    }
}
