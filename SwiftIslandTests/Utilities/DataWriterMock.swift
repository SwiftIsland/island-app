//
//  DataWriterMock.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-18.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation
@testable import SwiftIsland

class DataWriterMock: DataWriting {

  var writeInvokeCount: Int = 0
  var writeData: Data? = nil
  var writeTo: URL? = nil
  var writeError: Error? = nil

  func write(data: Data, to: URL) throws {
    writeInvokeCount += 1
    writeData = data
    writeTo = to

    if let error = writeError {
      throw error
    }
  }
}
