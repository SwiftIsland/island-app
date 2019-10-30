//
//  MapViewControllerTests.swift
//  SwiftIslandTests
//
//  Created by Ilya Gluschuk on 06/10/2019.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import XCTest
import MapKit
@testable import SwiftIsland

class MapViewControllerTests: XCTestCase {
  var viewController: MapViewController!
  var mapViewMock: MKMapViewMock!

  override func setUp() {
    mapViewMock = MKMapViewMock()

    viewController = MapViewController()
    viewController.mapView = mapViewMock
  }

  override func tearDown() {
    mapViewMock = nil
    viewController = nil
  }

  func test_user_location_outside_island() {
    // London coordinates
    let location = CLLocation(latitude: 51.509865, longitude: -0.118092)
    let locationMock = MKUserLocationMock(location: location)

    let expectation = XCTestExpectation(description: "test_user_location_outside_island")

    mapViewMock.onRegionSet = { [unowned self] region in
      let venueRegion = MapViewController.Regions.venue

      // Check that region is venue region
      self.assertEqualRegions(region, venueRegion)
      expectation.fulfill()
    }
    viewController.mapView(mapViewMock, didUpdate: locationMock)

    wait(for: [expectation], timeout: 1)
  }

  func test_region_set_one_time() {
    // London coordinates
    let location = CLLocation(latitude: 51.509865, longitude: -0.118092)
    let locationMock = MKUserLocationMock(location: location)

    let expectation = XCTestExpectation(description: "test_region_set_one_time")

    var invokeCount = 0
    mapViewMock.onRegionSet = { _ in
      invokeCount += 1
    }

    viewController.mapView(mapViewMock, didUpdate: locationMock)
    viewController.mapView(mapViewMock, didUpdate: locationMock)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
      XCTAssertEqual(invokeCount, 1)
      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 1)
  }

  func test_user_location_in_venue_region() {
    let location = CLLocation(latitude: 53.114673, longitude: 4.896890)
    let locationMock = MKUserLocationMock(location: location)

    let expectation = XCTestExpectation(description: "test_user_location_in_venue_region")

    mapViewMock.onRegionSet = { [unowned self] region in
      let venueRegion = MapViewController.Regions.venue

      // Check that region is venue region
      self.assertEqualRegions(region, venueRegion)
      expectation.fulfill()
    }
    viewController.mapView(mapViewMock, didUpdate: locationMock)

    wait(for: [expectation], timeout: 1)
  }

  func test_user_location_outside_venue_region() {
    let location = CLLocation(latitude: 53.144776, longitude: 4.831373)
    let locationMock = MKUserLocationMock(location: location)

    let expectation = XCTestExpectation(description: "test_user_location_in_venue_region")

    mapViewMock.onRegionSet = { [unowned self] region in
      let expectedRegion = MKCoordinateRegion(coordinateA: location.coordinate,
                                              coordinateB: MapViewController.Coordinates.venue)

      // Check that regions are equal
      self.assertEqualRegions(region, expectedRegion)
      expectation.fulfill()
    }
    viewController.mapView(mapViewMock, didUpdate: locationMock)

    wait(for: [expectation], timeout: 1)
  }

  func test_location_fail() {
    let expectation = XCTestExpectation(description: "test_location_fail")

    mapViewMock.onRegionSet = { [unowned self] region in
      let venueRegion = MapViewController.Regions.venue

      // Check that region is venue region
      self.assertEqualRegions(region, venueRegion)
      expectation.fulfill()
    }

    let error = NSError(domain: "test_error", code: 0, userInfo: nil)
    viewController.mapView(mapViewMock, didFailToLocateUserWithError: error)

    wait(for: [expectation], timeout: 1)
  }

  private func assertEqualRegions(_ region1: MKCoordinateRegion, _ region2: MKCoordinateRegion) {
    XCTAssertEqual(region1.center.latitude, region2.center.latitude, accuracy: 0.00001)
    XCTAssertEqual(region1.center.longitude, region2.center.longitude, accuracy: 0.00001)
    XCTAssertEqual(region1.span.latitudeDelta, region2.span.latitudeDelta, accuracy: 0.001)
    XCTAssertEqual(region1.span.longitudeDelta, region2.span.longitudeDelta, accuracy: 0.001)
  }
}
