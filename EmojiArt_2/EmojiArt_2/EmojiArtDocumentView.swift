//
//  EmojiArtDoucmentView.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/3/22.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document: EmojiArtDocument
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(EmojiArtDocument.paletteEmoji.map{ String($0) } ,id: \.self ){ emoji in
                        Text(emoji)
                            .font(.system(size: defaultEmojiSize))
                            .onDrag{  NSItemProvider(object: emoji as NSString)}
                    }
                }
                
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                Color.white.overlay(
                        Group{
                            if self.document.backgroundImage != nil {
                                Image(uiImage: self.document.backgroundImage!)
                            }
                        }
                        
                    )
                    .edgesIgnoringSafeArea([.horizontal,.bottom])
                    .onDrop(of: ["public.image","public.text"], isTargeted: nil) {provider, location in
                        var location = geometry.convert(location, from: .global)
                        location = CGPoint(x: location.x - geometry.size.width/2 , y: location.y - geometry.size.height/2 )
                        return self.drop(providers: provider, at: location)
                    }
                
                ForEach(self.document.emojis) { emoji in
                    Text(emoji.text)
                        .font(self.font(for: emoji))
                        .position(self.position(for: emoji, in: geometry.size))
                }
                
            }
            
        }
    }
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        CGPoint(x: emoji.location.x + size.width / 2 , y: emoji.location.y + size.height/2)
    }
    
    
    private func drop(providers: [NSItemProvider], at location : CGPoint ) -> Bool {
        var found = providers.loadObjects(ofType: URL.self){ url in
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self){ string in
                self.document.addEmoji(string, at: location , size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    
    private let defaultEmojiSize: CGFloat = 40.0
    
}

