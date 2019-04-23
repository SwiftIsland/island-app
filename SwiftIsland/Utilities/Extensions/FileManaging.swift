//
//  FileManaging.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

protocol FileManaging {
  func fileExists(atPath path: String) -> Bool
  func contents(atPath path: String) -> Data?
  
  func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey: Any]?) -> Bool
  func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
  func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
}

extension FileManager: FileManaging {}

protocol JSONEncoding {
  func encode<T>(_ value: T) throws -> Data where T: Encodable
  
  var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get set }
}

extension JSONEncoder: JSONEncoding { }
