//
//  FileManagerMock.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-09.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation
@testable import SwiftIsland

class FileManagerMock: FileManaging {

  var contentsInvokeCount = 0
  var contentsAtPath: String?
  var contentsReturnValue: [Data?] = []

  private let lock = NSLock()

  func contents(atPath path: String) -> Data? {
    lock.lock()
    defer { lock.unlock() }
    contentsInvokeCount += 1
    contentsAtPath = path

    return contentsReturnValue[safe: contentsInvokeCount - 1] ?? nil
  }
}
