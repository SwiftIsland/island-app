//
//  GradientView.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-22.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: DesignableView {

  @IBInspectable var firstColor: UIColor?
  @IBInspectable var secondColor: UIColor?
  @IBInspectable var startPoint: CGPoint = .zero
  @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 0)

  fileprivate var gradientMask: CAShapeLayer?

  lazy var gradientLayer: CAGradientLayer = {
    let newLayer = CAGradientLayer()
    newLayer.colors = [
      firstColor?.cgColor ?? UIColor(red: 0.99, green: 0.9, blue: 0.95, alpha: 1).cgColor,
      secondColor?.cgColor ?? UIColor(red: 0.97, green: 0.79, blue: 0.87, alpha: 1).cgColor
    ]
    newLayer.startPoint = startPoint
    newLayer.endPoint = endPoint
    newLayer.locations = [0, 1]
    newLayer.cornerRadius = cornerRadius
    newLayer.masksToBounds = true
    layer.insertSublayer(newLayer, at: 0)
    let mask = CAShapeLayer()
    mask.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 75),
                             byRoundingCorners: [.topLeft],
                             cornerRadii: CGSize(width: 10, height: 10)).cgPath
    layer.mask = mask
    self.gradientMask = mask

    return newLayer
  }()

  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
    gradientMask?.path = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                      cornerRadii: CGSize(width: 2, height: 2)).cgPath
  }
}
