//
//  FileManaging.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

protocol FileManaging {
  func contents(atPath path: String) -> Data?
}

extension FileManager: FileManaging {}
