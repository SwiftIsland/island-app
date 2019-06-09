//
//  BundleMock.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-09.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

class BundleMock: Bundle {

  var pathForResourceInvokeCount = 0
  var pathForResourceName: String?
  var pathForResourceType: String?
  var pathForResourceReturnValue: String?

  override func path(forResource name: String?, ofType ext: String?) -> String? {
    pathForResourceInvokeCount += 1
    pathForResourceName = name
    pathForResourceType = ext
    return pathForResourceReturnValue
  }
}
