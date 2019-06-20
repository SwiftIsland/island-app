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
  var apiManagerMock: APIManagerMock!

  override func setUp() {
    cacheManagerMock = CacheManagerMock()
    apiManagerMock = APIManagerMock()
    sut = DataManager(cacheManager: cacheManagerMock, apiManager: apiManagerMock)
  }

  override func tearDown() {
    sut = nil
    cacheManagerMock = nil
  }

  // MARK: getSchedule

  func test_getSchedule_successNoScheduleYet_shouldSuccessEmpty() {
    cacheManagerMock.getReturnValue = [Schedule]()
    apiManagerMock.getCompletionHandlerError = APIManagerError.apiReponseUnhandledStatusCode(statusCode: 404)
    let expectation = XCTestExpectation(description: "")

    sut.getSchedule { result in
      if case .failure(let error) = result {
        XCTAssertEqual(error, DataErrors.notYetAvailable)
      } else {
        XCTFail("Expected the result to not to be available yet")
      }
      expectation.fulfill()
    }

    XCTAssertEqual(apiManagerMock.getInvokeCount, 1)
    wait(for: [expectation], timeout: 1)
  }

  func test_getSchedule_successEmptyAPINoCache_shouldSuccessEmpty() {
    cacheManagerMock.getReturnValue = [Schedule]()
    apiManagerMock.getCompletionHandlerResult = [Schedule]()
    let expectation = XCTestExpectation(description: "")

    sut.getSchedule { result in
      if case .failure(let error) = result {
        XCTAssertEqual(error, DataErrors.notYetAvailable)
      }

      if case .success(let value) = result {
        XCTAssertEqual(value.count, 0)
      } else {
        XCTFail("Expected the result to be .success")
      }
      expectation.fulfill()
    }

    XCTAssertEqual(apiManagerMock.getInvokeCount, 1)
    wait(for: [expectation], timeout: 1)
  }

  func test_getSchedule_successErrorAPINoCache_shouldSuccessEmpty() {
    cacheManagerMock.getReturnValue = [Schedule]()
    apiManagerMock.getCompletionHandlerError = APIManagerError.apiReponseUnhandledStatusCode(statusCode: 1337)
    let expectation = XCTestExpectation(description: "")

    sut.getSchedule { result in
      if case .failure(let error) = result {
        XCTAssertEqual(error, DataErrors.notYetAvailable)
      }

      if case .success(let value) = result {
        XCTAssertEqual(value.count, 0)
      } else {
        XCTFail("Expected the result to be .success")
      }
      expectation.fulfill()
    }

    XCTAssertEqual(apiManagerMock.getInvokeCount, 1)
    wait(for: [expectation], timeout: 1)
  }

  func test_getSchedule_successApiErrorCache_shouldReturnFailure() {
    cacheManagerMock.getReturnValue = nil
    cacheManagerMock.getError = DataManagerTestsError.dummyError
    apiManagerMock.getCompletionHandlerError = APIManagerError.apiReponseUnhandledStatusCode(statusCode: 1337)
    let expectation = XCTestExpectation(description: "")

    sut.getSchedule { result in
      if case .failure(let error) = result {
        XCTAssertEqual(error, DataErrors.noData)
      } else {
        XCTFail("Expected the result to be .failure with error DataErrors.noData, got: \(result)")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  // MARK: Area

  func test_getArea_successNoAPINoCache_shouldSuccessEmpty() {
    cacheManagerMock.getReturnValue = [Area]()
    apiManagerMock.getCompletionHandlerError = APIManagerError.apiReponseUnhandledStatusCode(statusCode: 1337)
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

  func test_getArea_successAPI_shouldSuccessFromAPI() {
    cacheManagerMock.getReturnValue = [Area]()
    apiManagerMock.getCompletionHandlerResult = [Area(withName: "test")]
    let expectation = XCTestExpectation(description: "")

    sut.getArea { result in
      if case .success(let value) = result {
        XCTAssertEqual(value.count, 1)
        XCTAssertEqual(value.first?.name, "test")
      } else {
        XCTFail("Expected the result to be .success")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_getArea_noApiNoCache_shouldAreaSchedule() {
    cacheManagerMock.getReturnValue = nil
    cacheManagerMock.getError = DataManagerTestsError.dummyError
    apiManagerMock.getCompletionHandlerError = APIManagerError.apiReponseUnhandledStatusCode(statusCode: 1337)
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

  // MARK: Mentors

  func test_getMentors_successNoAPINoCache_shouldSuccessEmpty() {
    cacheManagerMock.getReturnValue = [Mentor]()
    apiManagerMock.getCompletionHandlerError = APIManagerError.apiReponseUnhandledStatusCode(statusCode: 1337)
    let expectation = XCTestExpectation(description: "")

    sut.getMentors { result in
      if case .success(let value) = result {
        XCTAssertEqual(value.count, 0)
      } else {
        XCTFail("Expected the result to be .success")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_getMentors_successAPI_shouldSuccessFromAPI() {
    cacheManagerMock.getReturnValue = [Mentor]()
    apiManagerMock.getCompletionHandlerResult = [Mentor(id: 0, name: "Test", image: "img", bio: "bio", twitter: nil, web: nil, country: nil)]
    let expectation = XCTestExpectation(description: "")

    sut.getMentors { result in
      if case .success(let value) = result {
        XCTAssertEqual(value.count, 1)
        XCTAssertEqual(value.first?.name, "Test")
      } else {
        XCTFail("Expected the result to be .success")
      }
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_getMentors_noApiNoCache_shouldAreaSchedule() {
    cacheManagerMock.getReturnValue = nil
    cacheManagerMock.getError = DataManagerTestsError.dummyError
    apiManagerMock.getCompletionHandlerError = APIManagerError.apiReponseUnhandledStatusCode(statusCode: 1337)
    let expectation = XCTestExpectation(description: "")

    sut.getMentors { result in
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
