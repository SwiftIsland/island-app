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
  case mentor, area

  var endpoint: APIManager.Endpoint {
    switch self {
    case .mentor:
      return .mentors
    case .area:
      return .area
    }
  }

  var cacheFiles: CacheFiles {
    switch self {
    case .mentor:
      return .mentors
    case .area:
      return .area
    }
  }
}

protocol DataManaging {
  func getSchedule(completion: @escaping (Result<[Schedule], DataErrors>) -> Void)
  func getAbout(completion: @escaping (Result<About, DataErrors>) -> Void)
  func get<T: Listable>(ofType type: ListableType, completion: @escaping (Result<[T], DataErrors>) -> Void)
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

  func getSchedule(completion: @escaping (Result<[Schedule], DataErrors>) -> Void) {

    _ = apiManager.get(endpoint: .schedule) { (result: Result<[Schedule], Error>) in
      switch result {
      case .success(let schedule):
        try? self.cacheManager.set(to: .schedule, data: schedule)
        completion(.success(schedule))
      case .failure(let fetchError):
        // If the fetch failed, first check the cache. If that fails too, then check the
        // error. Otherwise disregard the error and show the cached result instead.
        do {
          let schedule: [Schedule] = try self.cacheManager.get(from: .schedule)
          completion(.success(schedule))
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
  
  // Todo: Refactor together with get schedule
  func getAbout(completion: @escaping (Result<About, DataErrors>) -> Void) {

    _ = apiManager.get(endpoint: .about) { (result: Result<About, Error>) in
      switch result {
      case .success(let about):
        try? self.cacheManager.set(to: .about, data: about)
        completion(.success(about))
      case .failure(let fetchError):
        // If the fetch failed, first check the cache. If that fails too, then check the
        // error. Otherwise disregard the error and show the cached result instead.
        do {
          let about: About = try self.cacheManager.get(from: .about)
          completion(.success(about))
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

  func get<T: Listable>(ofType type: ListableType, completion: @escaping (Result<[T], DataErrors>) -> Void) {
    _ = apiManager.get(endpoint: type.endpoint) { (result: Result<[T], Error>) in
      switch result {
      case .success(let objects):
        try? self.cacheManager.set(to: type.cacheFiles, data: objects)
        completion(.success(objects))
      case .failure:
        do {
          let objects: [T] = try self.cacheManager.get(from: type.cacheFiles)
          completion(.success(objects))
        } catch {
          completion(.failure(.noData))
        }
      }
    }
  }
}
