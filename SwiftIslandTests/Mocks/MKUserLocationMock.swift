//
//  MKUserLocationMock.swift
//  SwiftIslandTests
//
//  Created by Ilya Gluschuk on 07/10/2019.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import MapKit

class MKUserLocationMock: MKUserLocation {
  private let mockedLocation: CLLocation?

  init(location: CLLocation) {
    mockedLocation = location
    super.init()
  }

  override var location: CLLocation? {
    return mockedLocation
  }
}
