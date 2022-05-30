//
//  Memorize_2App.swift
//  Memorize_2
//
//  Created by oeng hokleng on 5/5/22.
//

import SwiftUI

@main
struct Memorize_2App: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
