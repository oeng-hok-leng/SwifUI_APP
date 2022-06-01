//
//  Array+Identifiable.swift
//  Memorize_2
//
//  Created by oeng hokleng on 29/5/22.
//

import Foundation

extension Array where Element: Identifiable {
    
    func firstItem(matching: Element) -> Int? {
        for index in 0..<self.count {
            if(self[index].id == matching.id){
                return index
            }
        }
        return nil // TODO: bogus!
    }
}
