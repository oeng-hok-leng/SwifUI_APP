//
//  ImagePicker.swift
//  EmojiArt_2
//
//  Created by oeng hokleng on 6/27/22.
//

import UIKit
import SwiftUI

typealias PickedImageHandler = ( UIImage?) -> Void

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var handlePickedImage: PickedImageHandler
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var handlePickedImage : PickedImageHandler
        
        init(handlePickedImage : @escaping PickedImageHandler) {
            self.handlePickedImage = handlePickedImage
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            handlePickedImage(info[.originalImage] as? UIImage )
        }
        
    }
}
