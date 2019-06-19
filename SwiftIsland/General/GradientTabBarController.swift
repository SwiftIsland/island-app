//
//  GradientTabBarController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-19.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

@IBDesignable
class GradientTabBarController: UITabBarController {

  @IBInspectable var startColor: UIColor = UIColor.themeColor(.redDark)
  @IBInspectable var endColor: UIColor = UIColor.themeColor(.red)
  @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0.5)
  @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 0.5)

  let layerGradient = CAGradientLayer()

  override func viewDidLoad() {
    super.viewDidLoad()

    layerGradient.colors = [startColor.cgColor, endColor.cgColor]
    layerGradient.startPoint = startPoint
    layerGradient.endPoint = endPoint
    layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    self.tabBar.layer.insertSublayer(layerGradient, at: 0)
  }
}
