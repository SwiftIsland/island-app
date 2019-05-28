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
}

enum DataErrors: Error {
  case noData
}

class DataManager {

  static let shared = DataManager()
  private let cacheManager: CacheManaging

  init(cacheManager: CacheManaging = CacheManager()) {
    self.cacheManager = cacheManager
  }
}

extension DataManager: DataManaging {

  func getSchedule(completion: @escaping (Result<[Schedule], DataErrors>) -> Void) {
    do {
      let schedule: [Schedule] = try cacheManager.get(from: .schedule)
      completion(.success(schedule))
    } catch {
      completion(.failure(.noData))
    }
  }

  func getArea(completion: @escaping (Result<[Area], DataErrors>) -> Void) {
    do {
      let area: [Area] = try cacheManager.get(from: .area)
      completion(.success(area))
    } catch {
      completion(.failure(.noData))
    }
  }

  func getMentors(completion: @escaping (Result<[Mentor], DataErrors>) -> Void) {
    do {
      let mentors: [Mentor] = try cacheManager.get(from: .mentors)
      completion(.success(mentors))
    } catch {
      completion(.failure(.noData))
    }
  }
}
