//
//  MKMapViewMock.swift
//  SwiftIslandTests
//
//  Created by Ilya Gluschuk on 07/10/2019.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import MapKit

class MKMapViewMock: MKMapView {
  var onRegionSet: ((MKCoordinateRegion) -> Void)?

  override func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
    onRegionSet?(region)
  }
}
