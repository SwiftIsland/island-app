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
  private var selectedArea: Area? {
    didSet {
      if let selectedArea = selectedArea {
        let region = MKCoordinateRegion(center: selectedArea.center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapView.setRegion(region, animated: true)
      }
    }
  }

  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var cottagePickerView: UIView! {
    didSet {
      cottagePickerView.layer.cornerRadius = 12
    }
  }
  @IBOutlet weak var cottagePicker: UIPickerView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupMap()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getAreas()
  }
}

private extension MapViewController {

  func setupMap() {
    centerOnVenue()
  }

  func getAreas() {
    loadingSpinner.isHidden = false
    loadingSpinner.startAnimating()
    dataManager.get(ofType: .area) { (result: Result<[Area], DataErrors>) -> Void in
      self.loadingSpinner.stopAnimating()
      switch result {
      case .success(let areas):
        let areas = areas.sorted { $0.name < $1.name }
        self.setupMapOverlays(areas: areas)
      case .failure(let error):
        debugPrint("Error fetching areas: \(error.localizedDescription)")
      }
    }
  }

  func setupMapOverlays(areas: [Area]) {
    mapView.removeOverlays(mapView.overlays)
    self.areas = areas
    cottagePicker.reloadAllComponents()
    renderMapOverlays()
  }

  func renderMapOverlays() {
    for area in areas {
      let polygon = CottagePolygon(coordinates: area.locationCoordinate2D, count: area.locationCoordinate2D.count)
      polygon.cottageArea = area
      polygon.selected = selectedArea == nil ? true : selectedArea?.name == area.name
      mapView.addOverlay(polygon)
    }
  }

  func centerOnVenue() {
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
    } else if let cottageOverlay = overlay as? CottagePolygon, let polygonView = MapPolygon(cottage: cottageOverlay) {
      polygonView.alpha = polygonView.selected ? 1 : 0.5
      return polygonView
    }

    return MKPolylineRenderer(overlay: overlay)
  }
}

extension MapViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if row == 0 {
      selectedArea = nil
    } else {
      let area = areas[row-1]
      selectedArea = area
    }
    mapView.removeOverlays(mapView.overlays)
    renderMapOverlays()
  }
}

extension MapViewController: UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return areas.count + 1
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if row == 0 {
      return ""
    }

    return areas[row-1].name
  }
}
