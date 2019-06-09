//
//  CollectionExtension.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-09.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

extension Collection {

  /// Returns the element at the specified index if it's within bounds, otherwise returns nil.
  subscript (safe index: Index?) -> Iterator.Element? {
    guard let index = index else { return nil }
    return indices.contains(index) ? self[index] : nil
  }
}
