//
//  OptionalImage.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/8/22.
//

import SwiftUI

struct OptionalImage:View{
    var uiImage: UIImage?
    
    var body: some View {
        Group{
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
