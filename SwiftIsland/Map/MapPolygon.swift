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
    let text = "\(area.name)"
    let font = UIFont.systemFont(ofSize: 50.0)
    let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                      NSAttributedString.Key.font: font,
                      NSAttributedString.Key.foregroundColor: UIColor.themeColor(.redDark)]
    let fontSize = text.size(withAttributes: attributes)
    let polyRect = CGRect(x: 0,
                          y: (polygon.boundingMapRect.size.height - Double(fontSize.height)) / 2,
                          width: polygon.boundingMapRect.size.width,
                          height: Double(fontSize.height))

    UIGraphicsPushContext(context)
    text.draw(in: polyRect, withAttributes: attributes)
    UIGraphicsPopContext()

  }
}

final class CottagePolygon: MKPolygon {
  var cottageArea: Area?
  var selected: Bool = true
}
