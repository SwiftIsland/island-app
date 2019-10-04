//
//  MKCoordinateRegionExtension.swift
//  SwiftIsland
//
//  Created by Ilya Gluschuk on 04/10/2019.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
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
