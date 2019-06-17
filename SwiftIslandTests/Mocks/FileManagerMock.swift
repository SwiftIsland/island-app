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

  var urlsInvokeCount = 0
  var urlsFor: FileManager.SearchPathDirectory?
  var urlsIn: FileManager.SearchPathDomainMask?
  var urlsReturnValue: [URL] = []

  private let lock = NSLock()

  func contents(atPath path: String) -> Data? {
    lock.lock()
    defer { lock.unlock() }
    contentsInvokeCount += 1
    contentsAtPath = path

    return contentsReturnValue[safe: contentsInvokeCount - 1] ?? nil
  }

  func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
    lock.lock()
    defer { lock.unlock() }
    urlsInvokeCount += 1
    urlsFor = directory
    urlsIn = domainMask
    return urlsReturnValue
  }
}
