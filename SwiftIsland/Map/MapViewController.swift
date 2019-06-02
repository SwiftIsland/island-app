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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getAreas()
  }

  private func setupMap() {
    centerOnVenue()
  }

  private func getAreas() {
    dataManager.getArea { result in
      switch result {
      case .success(let areas):
        self.setupMapOverlays(areas: areas)
      case .failure(let error):
        debugPrint("Error fetching areas: \(error.localizedDescription)")
      }
    }
  }

  private func setupMapOverlays(areas: [Area]) {
    mapView.removeOverlays(mapView.overlays)
    self.areas = areas

    for area in areas {
      let polygon = MKPolygon(coordinates: area.locationCoordinate2D, count: area.locationCoordinate2D.count)
      mapView.addOverlay(polygon)

      // Add outer line
    }
  }

  private func centerOnVenue() {
    let location = CLLocation(latitude: 53.11492071953518, longitude: 4.89718462979863)
    centerMapOnLocation(location: location)
  }

  func centerMapOnLocation(location: CLLocation) {
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    DispatchQueue.main.async {
      self.mapView.setRegion(region, animated: true)
      let annotation = MKPointAnnotation()
      annotation.coordinate = location.coordinate
      self.mapView.addAnnotation(annotation)
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is MKPolyline {
      let polylineRenderer = MKPolylineRenderer(overlay: overlay)
      polylineRenderer.strokeColor = .orange
      polylineRenderer.lineWidth = 5
      return polylineRenderer
    } else if overlay is MKPolygon {
      let polygonView = MKPolygonRenderer(overlay: overlay)
      polygonView.fillColor = .magenta
      return polygonView
    }
    return MKPolylineRenderer(overlay: overlay)
  }
}
