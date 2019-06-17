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
  var dataWriterMock: DataWriterMock!

  override func setUp() {
    fileManagerMock = FileManagerMock()
    bundleMock = BundleMock()
    dataWriterMock = DataWriterMock()
    sut = CacheManager(fileManager: fileManagerMock, bundle: bundleMock, dataWriter: dataWriterMock)
  }

  override func tearDown() {
    sut = nil
    fileManagerMock = nil
    bundleMock = nil
    dataWriterMock = nil
  }

  func test_get_validFile_shouldReturn() {
    fileManagerMock.urlsReturnValue = [URL(fileURLWithPath: "/homedir")]
    fileManagerMock.contentsReturnValue.append(#"{"result":"value"}"#.data(using: .utf8))

    let result: [String:String]? = try? sut.get(from: CacheFiles.area)

    XCTAssertNotNil(result)
    XCTAssertEqual(fileManagerMock.contentsInvokeCount, 1)
    XCTAssertEqual(fileManagerMock.contentsAtPath, "/homedir/area.json")
    XCTAssertEqual(result?.keys.first, "result")
    XCTAssertEqual(result?.values.first, "value")
  }

  func test_get_fileNotFound_shouldThrow() {
    fileManagerMock.urlsReturnValue = []
    do {
      let _: [String:String]? = try sut.get(from: CacheFiles.area)
      XCTFail("Should throw .fileNotFound error")
    } catch {
      guard let error = error as? CacheErrors else { return XCTFail("Wrong error was thrown") }
      if case .fileNotFound = error { } else {
        XCTFail("Invalid error was throws. Expected .fileNotFound, got \(error.self)")
      }
    }

    XCTAssertEqual(fileManagerMock.contentsInvokeCount, 0)
  }

  func test_get_contentsNotFound_shouldThrow() {
    fileManagerMock.urlsReturnValue = [URL(fileURLWithPath: "/homedir")]

    do {
      let _: [String:String]? = try sut.get(from: CacheFiles.area)
      XCTFail("Should throw .fileNotFound error")
    } catch {
      guard let error = error as? CacheErrors else { return XCTFail("Wrong error was thrown") }
      if case .contentNotFound = error { } else {
        XCTFail("Invalid error was throws. Expected .contentNotFound, got \(error.self)")
      }
    }

    XCTAssertEqual(fileManagerMock.contentsInvokeCount, 1)
    XCTAssertEqual(fileManagerMock.contentsAtPath, "/homedir/area.json")
  }

  func test_set_validFile_shouldWrite() {
    fileManagerMock.urlsReturnValue = [URL(fileURLWithPath: "/homedir")]
    try? sut.set(to: .schedule, data: DummyCodable())

    guard let writeData = dataWriterMock.writeData else { XCTFail("Did not get data written."); return }
    let dataString = String(data: writeData, encoding: .utf8)

    XCTAssertEqual(dataWriterMock.writeInvokeCount, 1)
    XCTAssertEqual(dataWriterMock.writeTo?.path, "/homedir/schedule.json")
    XCTAssertEqual(dataString, "{}")
  }

  func test_set_fileNotFound_shouldThrow() {
    fileManagerMock.urlsReturnValue = []
    do {
      try sut.set(to: .schedule, data: DummyCodable())
      XCTFail("Should throw .fileNotFound error")
    } catch {
      guard let error = error as? CacheErrors else { return XCTFail("Wrong error was thrown") }
      if case .fileNotFound = error { } else {
        XCTFail("Invalid error was throws. Expected .fileNotFound, got \(error.self)")
      }
    }

    XCTAssertEqual(fileManagerMock.contentsInvokeCount, 0)
  }
}

public struct DummyCodable: Codable { }
