//
//  APIManagerTests.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-16.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
@testable import SwiftIsland

class APIManagerTests: XCTestCase {

  var sut: APIManager!
  var urlSessionMock: URLSessionMock!

  override func setUp() {
    urlSessionMock = URLSessionMock()
    sut = APIManager(baseURL: URL(string: "https://localhost/")!, urlSession: urlSessionMock)
  }

  override func tearDown() {
    sut = nil
    urlSessionMock = nil
  }

  // MARK: - Get -- Success

  func test_get_success_shouldReturnCorrectValue() {
    let expectation = XCTestExpectation(description: "")
    let endpoint = APIManager.Endpoint.area

    _ = sut.get(endpoint: endpoint) { (result: Result<[String:String], Error>) in
      self.validateRequest(urlSessionMock: self.urlSessionMock, url: "https://localhost/locations", httpMethod: "GET")
      XCTAssertEqual(try? result.get()["name"], "John Appleseed")

      expectation.fulfill()
    }

    let operationQueue = OperationQueue()
    operationQueue.addOperation {
      let validJson = "{ \"name\" : \"John Appleseed\" }".data(using: .utf8)
      self.urlSessionMock.dataTaskCompletionHandler?(validJson, nil, nil)
    }
    wait(for: [expectation], timeout: 10)
  }

  // MARK: - Get -- Error

  func test_get_error_shouldReturnCorrectValue() {
    let expectation = XCTestExpectation(description: "")
    let endpoint = APIManager.Endpoint.area

    _ = sut.get(endpoint: endpoint) { (result: Result<[String:String], Error>) in
      self.validateRequest(urlSessionMock: self.urlSessionMock, url: "https://localhost/locations", httpMethod: "GET")

      switch result {
      case .failure(let error):
        guard let error = error as? NetworkManagerTestError else {
          return XCTFail("Incorrect error returned")
        }
        XCTAssertEqual(error, NetworkManagerTestError.dummyError)
      default:
        XCTFail("Should have retruned error")
      }

      expectation.fulfill()
    }

    let operationQueue = OperationQueue()
    operationQueue.addOperation {
      self.urlSessionMock.dataTaskCompletionHandler?(nil, nil, NetworkManagerTestError.dummyError)
    }
    wait(for: [expectation], timeout: 10)
  }

  func test_get_invalidJSON_shouldReturnInvalidJsonError() {
    let expectation = XCTestExpectation(description: "")
    let endpoint = APIManager.Endpoint.mentors

    _ = sut.get(endpoint: endpoint) { (result: Result<[String:String], Error>) in
      self.validateRequest(urlSessionMock: self.urlSessionMock, url: "https://localhost/mentors", httpMethod: "GET")

      switch result {
      case .failure(let error):
        guard let _ = error as? DecodingError else {
          return XCTFail("Incorrect error returned")
        }
      default:
        XCTFail("Should have retruned error")
      }

      expectation.fulfill()
    }

    let operationQueue = OperationQueue()
    operationQueue.addOperation {
      let invalidJson = "Hello, world!".data(using: .utf8)
      self.urlSessionMock.dataTaskCompletionHandler?(invalidJson, nil, nil)
    }
    wait(for: [expectation], timeout: 10)
  }

  func test_get_invalidStatusCode_shouldReturnInvalidJsonError() {
    let expectation = XCTestExpectation(description: "")
    let endpoint = APIManager.Endpoint.mentors

    _ = sut.get(endpoint: endpoint) { (result: Result<[String:String], Error>) in
      self.validateRequest(urlSessionMock: self.urlSessionMock, url: "https://localhost/mentors", httpMethod: "GET")
      switch result {
      case .failure(let error):
        guard let error = error as? APIManagerError else {
          return XCTFail("Incorrect error returned")
        }
        XCTAssertEqual(error, APIManagerError.apiReponseUnhandledStatusCode(statusCode: 123))
      default:
        XCTFail("Should have retruned error")
      }

      expectation.fulfill()
    }

    let operationQueue = OperationQueue()
    operationQueue.addOperation {
      let response = HTTPURLResponse(url: URL(string: "http://local.host")!, statusCode: 123, httpVersion: nil, headerFields: nil)
      self.urlSessionMock.dataTaskCompletionHandler?(nil, response, nil)
    }
    wait(for: [expectation], timeout: 10)
  }

  func test_get_i_shouldReturnInvalidJsonError() {
    let expectation = XCTestExpectation(description: "")
    let endpoint = APIManager.Endpoint.schedule

    _ = sut.get(endpoint: endpoint) { (result: Result<[String:String], Error>) in
      self.validateRequest(urlSessionMock: self.urlSessionMock, url: "https://localhost/schedule", httpMethod: "GET")
      switch result {
      case .failure(let error):
        guard let error = error as? APIManagerError else {
          return XCTFail("Incorrect error returned")
        }
        XCTAssertEqual(error, APIManagerError.invalidData)
      default:
        XCTFail("Should have retruned error")
      }

      expectation.fulfill()
    }

    let operationQueue = OperationQueue()
    operationQueue.addOperation {
      self.urlSessionMock.dataTaskCompletionHandler?(nil, nil, nil)
    }
    wait(for: [expectation], timeout: 10)
  }
}

private extension APIManagerTests {

  func validateRequest(urlSessionMock: URLSessionMock, url: String, httpMethod: String) {
    // Headers
    XCTAssertEqual(urlSessionMock.dataTaskRequest?.httpMethod, httpMethod)

    // URL
    XCTAssertEqual(urlSessionMock.dataTaskRequest?.url?.absoluteString, url)

    // Invoke counts
    XCTAssertEqual(urlSessionMock.dataTaskInvokeCount, 1)
    XCTAssertEqual(urlSessionMock.dataTaskReturnUrlSessionDataTask.resumeInvokeCount, 1)
  }
}

private enum NetworkManagerTestError : Error {
  case dummyError
}
