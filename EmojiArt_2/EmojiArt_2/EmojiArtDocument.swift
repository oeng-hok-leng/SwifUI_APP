//
//  EmojiArtDocument.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/3/22.
//

import SwiftUI
import Combine


class EmojiArtDocument : ObservableObject,Hashable, Identifiable {
    
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    
    var id = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let paletteEmoji : String = "⭐️☁️🍎🌎👑⚾️"
    private static let emojidocument = "EmojiArtDocument.Untitled"
    
    @Published private var emojiArt: EmojiArt
    
    private var autoSaveCancellable: AnyCancellable?
    
    
    init(id: UUID? = nil){
        self.id = id ?? UUID()
        let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArt()
        autoSaveCancellable = $emojiArt.sink{ emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: defaultsKey)
        }
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    @Published  var steadyStatePanOffset: CGSize = .zero
    @Published  var steadyStateZoomScale: CGFloat = 1.0
    
    var emojis: [EmojiArt.Emoji]{ emojiArt.emojis }
    
   
    
    //MARK: - Intent
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat){
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offSet: CGSize){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis[index].x += Int(offSet.width)
            emojiArt.emojis[index].y += Int(offSet.height)
            
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat){
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven)) 
        }
    }
    
    var backgroundURL: URL? {
        set {
            
        
        emojiArt.backgroundURL = newValue?.imageURL
        fetchBackgroundImageData()
        }
        get {
            emojiArt.backgroundURL
        }
    }
    
    private var fetchImageCancellable : AnyCancellable?
    
    func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            fetchImageCancellable?.cancel()
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map{data, urlRespne in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
        
        }
    }
    
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size)}
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
}
