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
//    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let store = EmojiArtDocumentStore(directory: url)
    
    var body: some Scene {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let store = EmojiArtDocumentStore(directory: url)
        return WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
        }
    }
}
