//
//  PalleteChooser.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/9/22.
//

import SwiftUI

struct PalleteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPalette:String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack(alignment: .center,spacing: 20){
            Stepper( onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            },label: {EmptyView()})
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture{
                    self.showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor){
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPaletteEditor)
                        .environmentObject(self.document)
                        .frame(minWidth: 300, minHeight: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
        .onAppear{
            self.chosenPalette = self.document.defaultPalette
        }
    }
}



struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    @State var  paletteName: String = ""
    @State var emojisToAdd:String = ""
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack( spacing: 0){
            ZStack {
                Text("Palette Editor").font(.headline).padding()
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation{
                            self.isShowing = false
                        }
                    }, label: { Text("Done") } ).padding()
                }
                
            }
            
            Divider()
            Form {
                Section{
                    TextField("Palette Name", text: $paletteName,onEditingChanged: {began in
                        if !began {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                            
                        }
                    })
                    TextField("Add Emoji", text: $emojisToAdd,onEditingChanged: {began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPalette)
                            self.emojisToAdd = ""
                            
                        }
                    })
                }
                Section(header: Text("Remove Emoji")) {
                    Grid(chosenPalette.map{String($0)} ,id: \.self){ emoji in
                        Text(emoji)
                            .font(.system(size: self.fontSize))
                            .onTapGesture{
                                withAnimation{
                                    self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                                }
                            }
                        
                    }
                    .frame( height: self.height)
                    //                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 20, maximum: 30))]){
                    //                            ForEach(chosenPalette.map{String($0)} ,id: \.self){ emoji in
                    //                                Text(emoji)
                    //                                                   .onTapGesture{
                    //                                                       withAnimation{
                    //                                                           self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                    //                                                       }
                    //                                                   }
                    //
                    //                                            }
                    //                    }
                }
            }
            
        }
        .onAppear{
            self.paletteName = document.paletteNames[self.chosenPalette] ?? ""
        }
    }
    var height: CGFloat {
        CGFloat((chosenPalette.count  - 1) / 6 * 70 + 70 )
    }
    let fontSize: CGFloat = 40
}


struct PalleteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PalleteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
