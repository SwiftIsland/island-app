//
//  DataWriter.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-18.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

protocol DataWriting {
  func write(data: Data, to: URL) throws
}

class DataWriter: DataWriting {

  func write(data: Data, to: URL) throws {
    try data.write(to: to)
  }
}
