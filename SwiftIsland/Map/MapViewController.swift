//
//  MapViewController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-22.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  private let dataManager = DataManager.shared
  private var areas: [Area] = []

  @IBOutlet weak var mapView: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupMap()
  }

  private func setupMap() {
    centerOnVenue()
    getAreas()
  }

  private func getAreas() {

    dataManager.getArea { result in
      switch result {
      case .success(let areas):
        self.setupMapOverlays(areas: areas)
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }

  private func setupMapOverlays(areas: [Area]) {
    mapView.removeOverlays(mapView.overlays)
    self.areas = areas

    let locations = areas.map { $0.coordinates }
//    let polygon = MKPolygon(
  }

  private func centerOnVenue() {
    let location = CLLocation(latitude: 53.1148856, longitude: 4.895983)
    centerMapOnLocation(location: location)
  }

  func centerMapOnLocation(location: CLLocation) {
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    DispatchQueue.main.async {
      self.mapView.setRegion(region, animated: true)
      let annotation = MKPointAnnotation()
      annotation.coordinate = location.coordinate
      self.mapView.addAnnotation(annotation)
    }
  }
}

extension MapViewController: MKMapViewDelegate {

}
