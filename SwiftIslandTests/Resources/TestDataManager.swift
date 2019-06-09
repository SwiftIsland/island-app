//
//  TestDataManager.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-09.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

class TestDataManager {
  func getLocalTestAsset(forPath path: String) -> Data? {
    if let path = Bundle(for: TestDataManager.self).path(forResource: path, ofType: ""),
      let file = FileManager().contents(atPath: path)
    {
      return file as Data?
    }

    return nil
  }
}
