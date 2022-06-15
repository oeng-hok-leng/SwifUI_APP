//
//  EmojiArt_2App.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/3/22.
//

import SwiftUI

@main
struct EmojiArt_2App: App {
    let store  = EmojiArtDocumentStore(named: "Emoji Art")
    
    var body: some Scene {
        return WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
        }
    }
}
