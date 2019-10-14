//
//  MKCoordinateRegionExtension.swift
//  SwiftIsland
//
//  Created by Ilya Gluschuk on 04/10/2019.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
  /**
   Returns instace, containing both coordinates (A, B).
   */
  init(coordinateA: CLLocationCoordinate2D, coordinateB: CLLocationCoordinate2D) {
    let latDelta = abs(coordinateA.latitude - coordinateB.latitude)
    let lonDelta = abs(coordinateA.longitude - coordinateB.longitude)

    let minLat = fmin(coordinateA.latitude, coordinateB.latitude)
    let minLon = fmin(coordinateA.longitude, coordinateB.longitude)

    let center = CLLocationCoordinate2D(latitude: minLat + latDelta / 2,
                                        longitude: minLon + lonDelta / 2)
    let span = MKCoordinateSpan(latitudeDelta: latDelta * 1.1,
                                longitudeDelta: lonDelta * 1.1)

    self.init(center: center, span: span)
  }

  func contains(location: CLLocation) -> Bool {
    let nwCoordinate = northWestCoordinate
    let seCoordinate = southEastCoordinate
    let coordinate = location.coordinate

    return  coordinate.latitude  >= nwCoordinate.latitude &&
            coordinate.latitude  <= seCoordinate.latitude &&
            coordinate.longitude >= nwCoordinate.longitude &&
            coordinate.longitude <= seCoordinate.longitude
  }

  private var northWestCoordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: center.latitude  - (span.latitudeDelta  / 2.0),
                                  longitude: center.longitude - (span.longitudeDelta / 2.0))
  }

  private var southEastCoordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: center.latitude  + (span.latitudeDelta  / 2.0),
                                  longitude: center.longitude + (span.longitudeDelta / 2.0))

  }
}
