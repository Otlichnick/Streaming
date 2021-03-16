//
//  Array+Safe.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 15.03.2021.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
          return indices.contains(index) ? self[index] : nil
      }
}
