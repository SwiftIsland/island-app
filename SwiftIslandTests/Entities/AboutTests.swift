//
//  AboutTests.swift
//  SwiftIslandTests
//
//  Created by misteu on 04.10.19.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
@testable import SwiftIsland

class AboutTests: XCTestCase {
  func testJSONDecode() {
    guard let testFile = TestDataManager().getLocalTestAsset(forPath: "About_valid.json") else { XCTFail("Did not find test file"); return }
    let aboutContent: About? = try? JSONDecoder().decode(About.self, from: testFile)
    XCTAssertNotNil(aboutContent)
    XCTAssertEqual(aboutContent?.appInfo.appName, "SwiftIsland")
    XCTAssertEqual(aboutContent?.appInfo.latestAppVersion, "1.1.1")
    XCTAssertEqual(aboutContent?.appInfo.appDescription, "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
    XCTAssertEqual(aboutContent?.appInfo.organisers[0].handle, "@funky-monkey")
    XCTAssertEqual(aboutContent?.appInfo.organisers[1].handle, "@nvh")
    XCTAssertEqual(aboutContent?.eventInfo, "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
    XCTAssertEqual(aboutContent?.githubLink, "https://github.com/SwiftIsland/island-app")
    XCTAssertEqual(aboutContent?.contributors.count, 5)
  }
}
