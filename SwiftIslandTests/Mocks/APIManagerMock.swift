//
//  APIManagerMock.swift
//  SwiftIslandTests
//
//  Created by Paul Peelen on 2019-06-17.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation
@testable import SwiftIsland

class APIManagerMock: APIManaging {

  var getInvokeCount = 0
  var getEndpoint: APIManager.Endpoint?
  var getCompletionHandlerResult: Decodable?
  var getCompletionHandlerError: Error?
  var getReturnValue: URLSessionDataTask?

  func get<T: Decodable>(endpoint: APIManager.Endpoint, completionHandler: @escaping ((Result<T, Error>) -> Void)) -> URLSessionTask? {
    getInvokeCount += 1
    getEndpoint = endpoint

    if let result = getCompletionHandlerResult as? T {
      completionHandler(.success(result))
    } else if let error = getCompletionHandlerError {
      completionHandler(.failure(error))
    }

    return getReturnValue
  }
}
