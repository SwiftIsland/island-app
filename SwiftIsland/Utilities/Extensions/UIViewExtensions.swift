//
//  UIViewExtensions.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-21.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {}

extension UIView {

  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }

  @IBInspectable var isCircle: Bool {
    get {
      return  abs(layer.cornerRadius - frame.size.width) < 1.0
    }
    set {
      if newValue {
        let width = min(frame.size.width, frame.size.height)
        frame.size = CGSize(width: width, height: width)
        layer.cornerRadius = frame.size.width / 2
      }
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      var color: UIColor?
      if let cgColor = layer.borderColor {
        color = UIColor(cgColor: cgColor)
      }
      return color
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
}
