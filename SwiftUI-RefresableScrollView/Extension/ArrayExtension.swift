//
//  ArrayExtension.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import Foundation

extension Array {
    init(repeating: [Element], count: Int) {
      self.init([[Element]](repeating: repeating, count: count).flatMap {$0})
    }

    func repeated(count: Int) -> [Element] {
      return [Element](repeating: self, count: count)
    }

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
