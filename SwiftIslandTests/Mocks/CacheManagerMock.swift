//
//  CacheManagerMock.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-04-23.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation
@testable import SwiftIsland

enum CacheManagerMockError : Error {
  case isNotCorrectDecodable
}

class CacheManagerMock: CacheManaging {

  var getInvokeCount = 0
  var getFrom: CacheFiles?
  var getReturnValue: Decodable?
  var getError: Error?

  func get<T>(from file: CacheFiles) throws -> T where T : Decodable {
    getInvokeCount += 1
    getFrom = file

    if let error = getError {
      throw error
    } else if let returnValue = getReturnValue as? T {
      return returnValue
    }

    throw CacheManagerMockError.isNotCorrectDecodable
  }
}
