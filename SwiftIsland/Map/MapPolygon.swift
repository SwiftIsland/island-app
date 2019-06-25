//
//  MapPolygon.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-07.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation
import MapKit

final class MapPolygon: MKPolygonRenderer {

  let area: Area
  let selected: Bool

  init?(cottage: CottagePolygon) {
    guard let area = cottage.cottageArea else { return nil }
    self.area = area
    self.selected = cottage.selected
    super.init(polygon: cottage)

    fillColor = .themeColor(.yellowLight)
    strokeColor = .themeColor(.orange)
    lineWidth = 2
  }

  override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
    super.draw(mapRect, zoomScale: zoomScale, in: context)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50.0),
                      NSAttributedString.Key.foregroundColor: UIColor.themeColor(.redDark)]
    let polyRect = self.rect(for: polygon.boundingMapRect)

    UIGraphicsPushContext(context)
    "\(area.name)".draw(in: polyRect, withAttributes: attributes)
    UIGraphicsPopContext()
  }
}

final class CottagePolygon: MKPolygon {
  var cottageArea: Area?
  var selected: Bool = true
}
