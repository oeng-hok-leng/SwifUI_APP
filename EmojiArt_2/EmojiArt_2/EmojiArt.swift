//
//  EmojiArt.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 4/6/22.
//

import Foundation

struct EmojiArt {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable {
        var id : Int
        let text: String
        var x: Int
        var y: Int
        var size : Int
        
       fileprivate init(id: Int , text: String , x: Int , y: Int, size: Int){
            self.id = id
            self.text = text
            self.x = x
            self.y = y
            self.size = size
        }
        
    }
     private var uniqueId = 0
    
    mutating func addEmoji(_ text: String, x: Int , y : Int , size: Int){
        uniqueId += 1
        emojis.append(Emoji(id: uniqueId, text: text, x: x, y: y, size: size))
    }
    
}
