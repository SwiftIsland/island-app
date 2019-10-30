//
//  MKCoordinateRegionExtensionTests.swift
//  SwiftIslandTests
//
//  Created by Ilya Gluschuk on 06/10/2019.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
import MapKit
@testable import SwiftIsland

class MKCoordinateRegionExtensionTests: XCTestCase {
  func test_region_contains_location_1() {
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 7, longitude: 7),
                                    span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))

    XCTAssertTrue(region.contains(location: CLLocation(latitude: 6.7, longitude: 7.8)))
  }

  func test_region_contains_location_2() {
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 5.3, longitude: 4.1),
                                    span: MKCoordinateSpan(latitudeDelta: 2.1, longitudeDelta: 3.3))

    XCTAssertFalse(region.contains(location: CLLocation(latitude: 5, longitude: 1.5)))
    XCTAssertFalse(region.contains(location: CLLocation(latitude: 7, longitude: 4)))
    XCTAssertFalse(region.contains(location: CLLocation(latitude: 5, longitude: 7)))
    XCTAssertFalse(region.contains(location: CLLocation(latitude: 4, longitude: 4)))
  }

  func test_region_constructor() {
    let coordinateA = CLLocationCoordinate2D(latitude: 5, longitude: 5)
    let coordinateB = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    let region = MKCoordinateRegion(coordinateA: coordinateA, coordinateB: coordinateB)

    XCTAssertTrue(region.contains(location: CLLocation(latitude: 7.3, longitude: 6.4)))
    XCTAssertFalse(region.contains(location: CLLocation(latitude: 4.3, longitude: 3.2)))
  }
}
