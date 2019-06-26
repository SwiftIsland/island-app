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
  func set<T: Encodable>(to file: CacheFiles, data: T) throws
  func copyFromBundle(file: CacheFiles) throws
}

final class CacheManager: CacheManaging {
  private let fileManager: FileManaging
  private let bundle: Bundle
  private let dataWriter: DataWriting

  init(fileManager: FileManaging = FileManager.default, bundle: Bundle = Bundle.main, dataWriter: DataWriting = DataWriter()) {
    self.fileManager = fileManager
    self.bundle = bundle
    self.dataWriter = dataWriter
  }

  // MARK: - CacheManaging

  func get<T: Decodable>(from file: CacheFiles) throws -> T {
    guard let path = filePath(for: file) else { throw CacheErrors.fileNotFound }
    guard let data = fileManager.contents(atPath: path.path) else { throw CacheErrors.contentNotFound }

    let decoder = JSONDecoder()
    decoder.dutchDecodingStrategy()

    return try decoder.decode(T.self, from: data)
  }

  func set<T: Encodable>(to file: CacheFiles, data: T) throws {
    guard let path = filePath(for: file) else { throw CacheErrors.fileNotFound }

    let encoder = JSONEncoder()
    encoder.dutchEncodingStrategy()

    let data = try encoder.encode(data)
    try dataWriter.write(data: data, to: path)
  }

  func copyFromBundle(file: CacheFiles) throws {
    guard let path = bundle.path(forResource: file.rawValue, ofType: "json") else { throw CacheErrors.fileNotFound }
    guard let data = fileManager.contents(atPath: path) else { throw CacheErrors.contentNotFound }
    guard let destinationPath = filePath(for: file) else { throw CacheErrors.fileNotFound }

    try dataWriter.write(data: data, to: destinationPath)
  }

  private func filePath(for file: CacheFiles) -> URL? {
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    return documentsDirectory.appendingPathComponent("\(file.rawValue).json", isDirectory: false)
  }
}
