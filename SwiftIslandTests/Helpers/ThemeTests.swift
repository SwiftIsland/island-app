//
//  ThemeTests.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-09.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
@testable import SwiftIsland

class ThemeTests: XCTestCase {

  override func setUp() {
  }

  override func tearDown() {
  }

  func test_validColor_invoke_shouldReturnColor () {
    let result = Theme.orange.color

    XCTAssertEqual(result.hexString, "#FF8822")
  }

  func test_uiColorThemeColor_invoke_shouldReturnColor () {
    let result = UIColor.themeColor(.tag)

    XCTAssertEqual(result.hexString, "#93D047")
  }
}

/// From: https://stackoverflow.com/a/47357277/406677
private extension UIColor {
  var hexString: String {
    let colorRef = cgColor.components
    let r = colorRef?[0] ?? 0
    let g = colorRef?[1] ?? 0
    let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
    let a = cgColor.alpha

    var color = String(
      format: "#%02lX%02lX%02lX",
      lroundf(Float(r * 255)),
      lroundf(Float(g * 255)),
      lroundf(Float(b * 255))
    )

    if a < 1 {
      color += String(format: "%02lX", lroundf(Float(a)))
    }

    return color
  }
}
