//
//  Area.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-22.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation
import CoreLocation

struct Area: Decodable {
  let name: String
  let coordinates: [CLLocationCoordinate2D]

  enum CodingKeys: String, CodingKey {
    case name = "name"
    case coordinates = "coordinates"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)

    let coordinates = try values.decode([Double].self, forKey: .coordinates)

    self.coordinates = []
  }
}
