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

protocol JSONEncoding {
  func encode<T>(_ value: T) throws -> Data where T: Encodable
  
  var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get set }
}

extension JSONEncoder: JSONEncoding { }
