//
//  CacheManagerTests.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-09.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
@testable import SwiftIsland

class CacheManagerTests: XCTestCase {

  var sut: CacheManager!
  var fileManagerMock: FileManagerMock!
  var bundleMock: BundleMock!

  override func setUp() {
    fileManagerMock = FileManagerMock()
    bundleMock = BundleMock()
    sut = CacheManager(fileManager: fileManagerMock, bundle: bundleMock)
  }

  override func tearDown() {
    sut = nil
    fileManagerMock = nil
  }

  func test_get_validFile_shouldReturn() {
    bundleMock.pathForResourceReturnValue = "area.json"
    fileManagerMock.contentsReturnValue.append(#"{"result":"value"}"#.data(using: .utf8))

    let result: [String:String]? = try? sut.get(from: CacheFiles.area)

    XCTAssertNotNil(result)
    XCTAssertEqual(bundleMock.pathForResourceInvokeCount, 1)
    XCTAssertEqual(bundleMock.pathForResourceName, "area")
    XCTAssertEqual(bundleMock.pathForResourceType, "json")
    XCTAssertEqual(fileManagerMock.contentsInvokeCount, 1)
    XCTAssertEqual(fileManagerMock.contentsAtPath, "area.json")
    XCTAssertEqual(result?.keys.first, "result")
    XCTAssertEqual(result?.values.first, "value")
  }

  func test_get_fileNotFound_shouldThrow() {
    do {
      let _: [String:String]? = try sut.get(from: CacheFiles.area)
      XCTFail("Should throw .fileNotFound error")
    } catch {
      guard let error = error as? CacheErrors else { return XCTFail("Wrong error was thrown") }
      if case .fileNotFound = error { } else {
        XCTFail("Invalid error was throws. Expected .fileNotFound, got \(error.self)")
      }
    }

    XCTAssertEqual(bundleMock.pathForResourceInvokeCount, 1)
    XCTAssertEqual(bundleMock.pathForResourceName, "area")
    XCTAssertEqual(bundleMock.pathForResourceType, "json")
    XCTAssertEqual(fileManagerMock.contentsInvokeCount, 0)
  }

  func test_get_contentsNotFound_shouldThrow() {
    bundleMock.pathForResourceReturnValue = "area.json"

    do {
      let _: [String:String]? = try sut.get(from: CacheFiles.area)
      XCTFail("Should throw .fileNotFound error")
    } catch {
      guard let error = error as? CacheErrors else { return XCTFail("Wrong error was thrown") }
      if case .contentNotFound = error { } else {
        XCTFail("Invalid error was throws. Expected .fileNotFound, got \(error.self)")
      }
    }

    XCTAssertEqual(bundleMock.pathForResourceInvokeCount, 1)
    XCTAssertEqual(bundleMock.pathForResourceName, "area")
    XCTAssertEqual(bundleMock.pathForResourceType, "json")
    XCTAssertEqual(fileManagerMock.contentsInvokeCount, 1)
    XCTAssertEqual(fileManagerMock.contentsAtPath, "area.json")
  }
}

public struct DummyCodable: Codable { }
