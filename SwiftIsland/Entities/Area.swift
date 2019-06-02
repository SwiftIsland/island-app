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
  let coordinates: [Coordinate]
  let locationCoordinate2D: [CLLocationCoordinate2D]

  struct Coordinate: Codable {
    var latitude: Double {
      return coordinate.latitude
    }
    var longitude: Double {
      return coordinate.longitude
    }
    let coordinate: CLLocationCoordinate2D

    public enum CodingKeys: String, CodingKey {
      case latitude
      case longitude
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(latitude, forKey: .latitude)
      try container.encode(longitude, forKey: .longitude)
    }

    public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      let latitude = try values.decode(Double.self, forKey: .latitude)
      let longitude = try values.decode(Double.self, forKey: .longitude)

      coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
  }

  enum CodingKeys: String, CodingKey {
    case name = "name"
    case coordinates = "coordinates"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    let coordinates = try values.decode([Coordinate].self, forKey: .coordinates)
    self.coordinates = coordinates

    let locationCoordinate2D = coordinates.compactMap({ $0.coordinate })
    self.locationCoordinate2D = locationCoordinate2D
  }
}
