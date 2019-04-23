//
//  DataManagerTests.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-04-23.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
@testable import SwiftIsland

enum DataManagerTestsError: Error {
  case dummyError
}

class DataManagerTests: XCTestCase {

  var sut: DataManager!
  var cacheManagerMock: CacheManagerMock!

  override func setUp() {
    cacheManagerMock = CacheManagerMock()
    sut = DataManager(cacheManager: cacheManagerMock)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: getSchedule

  func test_getSchedule_successNoSchedule_shouldSuccessEmpty() {
    cacheManagerMock.getReturnValue = [Schedule]()
    let expectation = XCTestExpectation(description: "")

    sut.getSchedule { result in
      if case .success(let value) = result {
        XCTAssertEqual(value.count, 0)
      } else {
        XCTFail("Expected the result to be .success")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_getSchedule_successSchedule_shouldSuccessSchedule() {
    cacheManagerMock.getReturnValue = nil
    cacheManagerMock.getError = DataManagerTestsError.dummyError
    let expectation = XCTestExpectation(description: "")

    sut.getSchedule { result in
      if case .failure(let error) = result {
        XCTAssertEqual(error, DataErrors.noData)
      } else {
        XCTFail("Expected the result to be .failure with error DataErrors.noData")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  // MARK: Area

  func test_getArea_successNoArea_shouldSuccessEmpty() {
    cacheManagerMock.getReturnValue = [Area]()
    let expectation = XCTestExpectation(description: "")

    sut.getArea { result in
      if case .success(let value) = result {
        XCTAssertEqual(value.count, 0)
      } else {
        XCTFail("Expected the result to be .success")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_getArea_successSchedule_shouldAreaSchedule() {
    cacheManagerMock.getReturnValue = nil
    cacheManagerMock.getError = DataManagerTestsError.dummyError
    let expectation = XCTestExpectation(description: "")

    sut.getArea { result in
      if case .failure(let error) = result {
        XCTAssertEqual(error, DataErrors.noData)
      } else {
        XCTFail("Expected the result to be .failure with error DataErrors.noData")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }
}
