//
//  CacheManager.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

enum CacheFiles: String {
  case schedule
  case area
  case mentors
}

enum CacheErrors: Error {
  case unknown
  case fileNotFound
  case contentNotFound
}

protocol CacheManaging {
  func get<T: Decodable>(from file: CacheFiles) throws -> T
}

final class CacheManager: CacheManaging {
  private let fileManager: FileManaging

  init(fileManager: FileManaging = FileManager.default) {
    self.fileManager = fileManager
  }

  //MARK: - CacheManaging

  func get<T: Decodable>(from file: CacheFiles) throws -> T {
    guard let path = Bundle.main.path(forResource: file.rawValue, ofType: "json") else { throw CacheErrors.fileNotFound }
    guard let data = fileManager.contents(atPath: path) else { throw CacheErrors.contentNotFound }
    let decoder = JSONDecoder()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    decoder.dateDecodingStrategy = .formatted(dateFormatter)

    return try decoder.decode(T.self, from: data)
  }
}
