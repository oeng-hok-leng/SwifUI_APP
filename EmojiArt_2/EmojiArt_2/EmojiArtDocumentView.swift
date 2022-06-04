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
                    }
                }
                
            }
            .padding(.horizontal)
            
            Rectangle()
                .foregroundColor(.yellow)
                .edgesIgnoringSafeArea([.horizontal,.bottom])
            
        }
        .padding(.top, 5 )
        
        
        
    }
    
    private let defaultEmojiSize: CGFloat = 40.0
    
}

