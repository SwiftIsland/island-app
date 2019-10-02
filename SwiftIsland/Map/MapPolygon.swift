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

    let attributes = textAttributes(with: UIFont.systemFont(ofSize: 50.0),
                                    textAlignment: .center,
                                    color: UIColor.themeColor(.redDark))
    let text = area.name
    let textSize = text.size(withAttributes: attributes)
    let boundingSize = polygon.boundingSize
    let polyRect = CGRect(x: 0,
                          y: (boundingSize.height - textSize.height) / 2,
                          width: CGFloat(boundingSize.width),
                          height: textSize.height)

    UIGraphicsPushContext(context)
    text.draw(in: polyRect, withAttributes: attributes)
    UIGraphicsPopContext()
  }

  private func textAttributes(with font: UIFont, textAlignment: NSTextAlignment, color: UIColor) -> [NSAttributedString.Key: Any] {
    let paragraphStyle: NSParagraphStyle = {
      let result = NSMutableParagraphStyle()
      result.alignment = textAlignment
      return result
    }()
    return [.paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: color]
  }
}

final class CottagePolygon: MKPolygon {
  var cottageArea: Area?
  var selected: Bool = true
}

private extension MKPolygon {
  var boundingSize: CGSize {
    return CGSize(width: boundingMapRect.width, height: boundingMapRect.height)
  }
}
