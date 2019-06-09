//
//  AreaTests.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-09.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
@testable import SwiftIsland

class AreaTests: XCTestCase {

  func test_decode_invoke_shouldSetupCorrectly() {
    guard let testFile = TestDataManager().getLocalTestAsset(forPath: "Area_valid.json") else { XCTFail("Did not find test file"); return }
    let area: Area? = try? JSONDecoder().decode(Area.self, from: testFile)

    XCTAssertNotNil(area)
    XCTAssertEqual(area?.center.latitude, 53.114498138427734)
    XCTAssertEqual(area?.center.longitude, 4.896526336669922)
    XCTAssertEqual(area?.points.count, 5)
    XCTAssertEqual(area?.name, "cottage")
    XCTAssertEqual(area?.locationCoordinate2D.count, 5)

    // Might seem as a stupid test, but its good to verify that the right coordinate is returned from CLLocationCoordinate2d when asing for e.g. latitude
    guard let firstPoint = area?.points.first else { XCTFail("Did not find point"); return }
    XCTAssertEqual(firstPoint.latitude, firstPoint.coordinate.latitude)
    XCTAssertEqual(firstPoint.longitude, firstPoint.coordinate.longitude)
  }
}
