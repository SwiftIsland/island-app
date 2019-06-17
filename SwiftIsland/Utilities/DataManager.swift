//
//  DataManager.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

protocol DataManaging {
  func getSchedule(completion: @escaping (Result<[Schedule], DataErrors>) -> Void)
  func getArea(completion: @escaping (Result<[Area], DataErrors>) -> Void)
  func getMentors(completion: @escaping (Result<[Mentor], DataErrors>) -> Void)
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
      case .failure(let error):
        if let networkError = error as? APIManagerError,
          case .apiReponseUnhandledStatusCode(let statusCode) = networkError,
          statusCode == 404
        {
          completion(.failure(.notYetAvailable))
        } else {
          do {
            let schedule: [Schedule] = try self.cacheManager.get(from: .schedule)
            completion(.success(schedule))
          } catch {
            completion(.failure(.noData))
          }
        }
      }
    }
  }

  func getArea(completion: @escaping (Result<[Area], DataErrors>) -> Void) {

    _ = apiManager.get(endpoint: .area) { (result: Result<[Area], Error>) in
      switch result {
      case .success(let locations):
        try? self.cacheManager.set(to: .area, data: locations)
        completion(.success(locations))
      case .failure:
        do {
          let area: [Area] = try self.cacheManager.get(from: .area)
          completion(.success(area))
        } catch {
          completion(.failure(.noData))
        }
      }
    }
  }

  func getMentors(completion: @escaping (Result<[Mentor], DataErrors>) -> Void) {

    _ = apiManager.get(endpoint: .mentors) { (result: Result<[Mentor], Error>) in
      switch result {
      case .success(let mentors):
        try? self.cacheManager.set(to: .mentors, data: mentors)
        completion(.success(mentors))
      case .failure:
        do {
          let mentors: [Mentor] = try self.cacheManager.get(from: .mentors)
          completion(.success(mentors))
        } catch {
          completion(.failure(.noData))
        }
      }
    }
  }
}
