//
//  Array+Only.swift
//  Memorize_2
//
//  Created by oeng hokleng on 29/5/22.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
