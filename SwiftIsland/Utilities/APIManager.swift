//
//  APIManager.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

enum APIManagerError: Error, Equatable {
  case invalidData
  case apiReponseUnhandledStatusCode(statusCode: Int)
}

protocol APIManaging {
  func get<T: Decodable>(endpoint: APIManager.Endpoint, completionHandler: @escaping ((Result<T, Error>) -> Void)) -> URLSessionTask?
}

final class APIManager: APIManaging {

  enum Endpoint: String {
    case schedule
    case mentors
    case area = "locations"
    case about
  }

  private let baseURL: URL
  private let urlSession: URLSession

  init(baseURL: URL, urlSession: URLSession = URLSession.shared) {
    self.baseURL = baseURL
    self.urlSession = urlSession
  }

  func get<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping ((Result<T, Error>) -> Void)) -> URLSessionTask? {
    return request(endpoint: endpoint, completionHandler: completionHandler)
  }

  // MARK: - Private

  private func request<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping ((Result<T, Error>) -> Void)) -> URLSessionTask? {

    let completionHandlerOnMain: ((Result<T, Error>) -> Void) = { result in
      DispatchQueue.main.async {
        completionHandler(result)
      }
    }

    return request(endPoint: endpoint) { (data, response, error) in
      if let error = error {
        completionHandlerOnMain(.failure(error))
        return
      }

      if let urlResponse = response as? HTTPURLResponse, !(200..<300).contains(urlResponse.statusCode) {
        completionHandlerOnMain(.failure(APIManagerError.apiReponseUnhandledStatusCode(statusCode: urlResponse.statusCode)))
        return
      }

      guard let data = data else {
        completionHandlerOnMain(.failure(APIManagerError.invalidData))
        return
      }

      let decoder = JSONDecoder()
      decoder.dutchDecodingStrategy()

      do {
        let decoded = try decoder.decode(T.self, from: data)
        completionHandlerOnMain(.success(decoded))
      } catch {
        completionHandlerOnMain(.failure(error))
      }
    }
  }

  private func request(endPoint: Endpoint, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTask? {
    var request = URLRequest(url: baseURL.appendingPathComponent(endPoint.rawValue))
    request.httpMethod = "GET"

    let task = urlSession.dataTask(with: request, completionHandler: completionHandler)
    task.resume()

    return task
  }
}
