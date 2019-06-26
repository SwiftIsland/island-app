//
//  JSONDecoder.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-26.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

enum JSONDecoderError: Error {
  case invalidDate
}

extension JSONDecoder {

  func dutchDecodingStrategy() {
    self.dateDecodingStrategy = .formatted(DateFormatter.dutchTimezone())
  }
}

extension JSONEncoder {

  func dutchEncodingStrategy() {
    self.dateEncodingStrategy = .formatted(DateFormatter.dutchTimezone())
  }
}

extension DateFormatter {

  static func dutchTimezone() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    formatter.timeZone = TimeZone(secondsFromGMT: 60*60*2)

    return formatter
  }
}
