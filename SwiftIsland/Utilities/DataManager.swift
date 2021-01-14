//
//  DataManager.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

protocol Listable: Codable {}
enum ListableType {
  case mentor, area, schedule, about

  var endpoint: APIManager.Endpoint {
    switch self {
    case .mentor:
      return .mentors
    case .area:
      return .area
    case .schedule:
      return .schedule
    case .about:
      return .about
    }
  }

  var cacheFiles: CacheFiles {
    switch self {
    case .mentor:
      return .mentors
    case .area:
      return .area
    case .schedule:
      return .schedule
    case .about:
      return .about
    }
  }
}

protocol DataManaging {
  func get<T: Listable>(ofType type: ListableType, completion: @escaping (Result<[T], DataErrors>) -> Void)
  func get<T: Listable>(ofType type: ListableType, completion: @escaping (Result<T, DataErrors>) -> Void)
}

enum DataErrors: Error {
  case noData
  case notYetAvailable
  case unhandledError
}

class DataManager {

  static let shared = DataManager()
  private let cacheManager: CacheManaging
  private let apiManager: APIManaging

  init(cacheManager: CacheManaging = CacheManager(), apiManager: APIManaging? = nil) {
    self.cacheManager = cacheManager

    if let apiManager = apiManager {
      self.apiManager = apiManager
    } else {
      guard let baseURL = URL(string: "https://swiftisland.herokuapp.com/") else { fatalError("This should never happen!") }
      self.apiManager = APIManager(baseURL: baseURL)
    }
  }
}

extension DataManager: DataManaging {
  func get<T: Listable>(ofType type: ListableType, completion: @escaping (Result<[T], DataErrors>) -> Void) {
    _ = apiManager.get(endpoint: type.endpoint) { (result: Result<[T], Error>) in
      switch result {
      case .success(let objects):
        try? self.cacheManager.set(to: type.cacheFiles, data: objects)
        completion(.success(objects))
      case .failure(let fetchError):
        do {
          let objects: [T] = try self.cacheManager.get(from: type.cacheFiles)
          completion(.success(objects))
        } catch {
          if let networkError = fetchError as? APIManagerError,
            case .apiReponseUnhandledStatusCode(let statusCode) = networkError,
            statusCode == 404 {
            completion(.failure(.notYetAvailable))
          } else {
            completion(.failure(.noData))
          }
        }
      }
    }
  }
  
  func get<T: Listable>(ofType type: ListableType, completion: @escaping (Result<T, DataErrors>) -> Void) {
    _ = apiManager.get(endpoint: type.endpoint) { (result: Result<T, Error>) in
      switch result {
      case .success(let object):
        try? self.cacheManager.set(to: type.cacheFiles, data: object)
        completion(.success(object))
      case .failure(let fetchError):
        do {
          let object: T = try self.cacheManager.get(from: type.cacheFiles)
          completion(.success(object))
        } catch {
          if let networkError = fetchError as? APIManagerError,
            case .apiReponseUnhandledStatusCode(let statusCode) = networkError,
            statusCode == 404 {
            completion(.failure(.notYetAvailable))
          } else {
            completion(.failure(.noData))
          }
        }
      }
    }
  }

}
