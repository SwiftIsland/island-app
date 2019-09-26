//
//  Area.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-22.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import CoreLocation
import GLKit

struct Area: Codable {
  let name: String
  let points: [Point]
  let locationCoordinate2D: [CLLocationCoordinate2D]

  var center: CLLocationCoordinate2D {
    var locationX: Float = 0.0
    var locationY: Float = 0.0
    var locationZ: Float = 0.0
    for points in locationCoordinate2D {
      let lat = GLKMathDegreesToRadians(Float(points.latitude))
      let long = GLKMathDegreesToRadians(Float(points.longitude))

      locationX += cos(lat) * cos(long)
      locationY += cos(lat) * sin(long)
      locationZ += sin(lat)
    }
    locationX /= Float(locationCoordinate2D.count)
    locationY /= Float(locationCoordinate2D.count)
    locationZ /= Float(locationCoordinate2D.count)

    let resultLong = atan2(locationY, locationX)
    let resultHyp = sqrt(locationX * locationX + locationY * locationY)
    let resultLat = atan2(locationZ, resultHyp)
    let result = CLLocationCoordinate2D(latitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLat))),
                                        longitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLong))))
    return result
  }

  struct Point: Codable {
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

    public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      let latitude = try values.decode(Double.self, forKey: .latitude)
      let longitude = try values.decode(Double.self, forKey: .longitude)

      coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(self.latitude, forKey: .latitude)
      try container.encode(self.longitude, forKey: .longitude)
    }

    init(withCoordinate coordinate: CLLocationCoordinate2D) {
      self.coordinate = coordinate
    }
  }

  enum CodingKeys: String, CodingKey {
    case name
    case points
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    let points = try values.decode([Point].self, forKey: .points)
    self.points = points

    let locationCoordinate2D = points.compactMap({ $0.coordinate })
    self.locationCoordinate2D = locationCoordinate2D
  }

  init(withName name: String, points: [Point] = [], locationCoordinate2d: [CLLocationCoordinate2D] = []) {
    self.name = name
    self.points = points
    self.locationCoordinate2D = locationCoordinate2d
  }
}

extension Area: Listable {}
