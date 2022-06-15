//
//  EmojiArtDoucmentView.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/3/22.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document: EmojiArtDocument
    
    @State private var chosenPalette: String = ""
    
    
    init(document: EmojiArtDocument){
        self.document = document
        _chosenPalette = State(wrappedValue: self.document.defaultPalette)
    }
    
    var body: some View {
        VStack{
            HStack{
                PalleteChooser(document: document, chosenPalette: $chosenPalette)
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(chosenPalette.map{ String($0) } ,id: \.self ){ emoji in
                            Text(emoji)
                                .font(.system(size: defaultEmojiSize))
                                .onDrag{  NSItemProvider(object: emoji as NSString)}
                        }
                    }
                    
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                        
                    )
                    .gesture(self.doubleTapToZoom(in: geometry.size))
                    .gesture(self.panGesture())
                    
                    if self.isLoading {
                        ProgressView()
                    }else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                            
                        }
                    }
                }
                .clipped()
                .gesture(self.zoomGesture())
                .edgesIgnoringSafeArea([.horizontal,.bottom])
                .onReceive(document.$backgroundImage) { image in
                    zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image","public.text"], isTargeted: nil) {provider, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2 , y: location.y - geometry.size.height/2 )
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height )
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: provider, at: location)
                }
                .navigationBarItems(
                    trailing:
                        Button(
                            action: {
                                // what is UIPasteBoard
                                if let url = UIPasteboard.general.url , url != self.document.backgroundURL {
                                    confirmBackgroundPaste = true
                                }else {
                                    explainBackgroundPaste = true
                                }
                            },
                            label: {
                                Image(systemName: "doc.on.clipboard")
                                    .imageScale(.large)
                                    .alert(isPresented: $explainBackgroundPaste){
                                        return Alert(title: Text("Paste Background"),
                                                     message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of your document "),
                                                     dismissButton: .default(Text("OK"))
                                        )
                                    }
                                    
                                    
                                
                            }
                        )
                )
            }
            .zIndex(-1)
        }
        .alert(isPresented: $confirmBackgroundPaste){
            Alert(
                title: Text("Paste Background"),
                message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                primaryButton: .default(Text("OK")) {
                    self.document.backgroundURL = UIPasteboard.general.url
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    
    
    
    @State private var explainBackgroundPaste = false;
    @State private var confirmBackgroundPaste = false;
    
    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
        
    }
    
    
    
    
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        document.steadyStateZoomScale * gestureZoomScale
    }
    
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale){ latestGestureScale, gestureZoomScale , transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded{ finalGestureScale in
                document.steadyStateZoomScale *= finalGestureScale
            }
    }
    
  
    @GestureState private var gesturePanOffSet: CGSize = .zero
    
    private var panOffset: CGSize{
        (document.steadyStatePanOffset + gesturePanOffSet) * self.zoomScale
    }
    
    private func panGesture() -> some Gesture{
        DragGesture()
            .updating($gesturePanOffSet){ latestDragGestureValue, gesturePanOffSet, transaction in
                gesturePanOffSet = latestDragGestureValue.translation / self.zoomScale
                
            }
            .onEnded{ finalDragGestureValue in
                self.document.steadyStatePanOffset = document.steadyStatePanOffset + (finalDragGestureValue.translation  / self.zoomScale)
                
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize){
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0 , size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.document.steadyStatePanOffset = .zero
            self.document.steadyStateZoomScale = min(hZoom, vZoom)
            
        }
    }
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize * self.zoomScale)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        
        location = CGPoint(x: location.x * self.zoomScale, y: location.y * self.zoomScale)
        location = CGPoint(x: location.x + size.width / 2 , y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        
        return location
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2).onEnded{
            withAnimation{
                zoomToFit(self.document.backgroundImage, in: size)
            }
        }
    }
    
    private func drop(providers: [NSItemProvider], at location : CGPoint ) -> Bool {
        var found = providers.loadObjects(ofType: URL.self){ url in
            self.document.backgroundURL = url
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


