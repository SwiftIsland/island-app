//
//  URLSessionMock.swift
//  ICATests
//
//  Copyright © 2019 Paul Peelen. All rights reserved.
//

import Foundation

final class URLSessionMock : URLSession {

  var dataTaskInvokeCount = 0
  var dataTaskRequest: URLRequest?
  var dataTaskCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)?
  var dataTaskReturnUrlSessionDataTask: URLSessionDataTaskMock = URLSessionDataTaskMock()

  var didCallDataTaskWithRequestCompletionHandler: (() -> Void)?

  var invalidateAndCancelInvokeCount = 0

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    dataTaskInvokeCount += 1
    dataTaskRequest = request
    dataTaskCompletionHandler = completionHandler

    didCallDataTaskWithRequestCompletionHandler?()

    return dataTaskReturnUrlSessionDataTask
  }

  override func invalidateAndCancel() {
    invalidateAndCancelInvokeCount += 1
  }
}

final class URLSessionDataTaskMock : URLSessionDataTask {

  var resumeInvokeCount = 0

  override func resume() {
    resumeInvokeCount += 1
  }
}
