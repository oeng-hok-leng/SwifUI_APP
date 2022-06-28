//
//  EmojiArtDocumentChooser.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/14/22.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    @State private var editMode: EditMode = .inactive
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) {document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document)
                        .navigationBarTitle(self.store.name(for: document))
                    ){
                        EditableText(self.store.name(for: document), isEditing: self.editMode.isEditing) { name in
                            self.store.setName(name, for: document)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map{ self.store.documents[$0] }.forEach { document in
                        withAnimation{
                            self.store.removeDocument(document)
                        }
                    }
                }
            }
            .navigationTitle(self.store.name)
            .navigationBarItems(
                
                leading: Button(action: {
                            withAnimation{
                                self.store.addDocument()
                            }
                        },label:{
                                Image(systemName: "plus").imageScale(.large)
                        }
                    ),
                trailing: EditButton(
                
                )
            )
            .environment(\.editMode, $editMode)
            
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
