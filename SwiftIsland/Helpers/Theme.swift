//
//  Theme.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-07.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

enum Theme: String {
  case tag
  case tagFont
  case scheduleTimeline
  case scheduleTimelineFont
  case textBody
  case textDefault

  case yellowLight
  case yellow
  case orangeLight
  case orange
  case red
  case redDark
}

extension Theme {

  var color: UIColor {
    guard let instanceColor = UIColor(named: self.rawValue) else {
      return .clear
    }

    return instanceColor
  }

  static var fadedAlpha: CGFloat {
    return 0.4
  }
}

extension UIColor {

  static func themeColor(_ theme: Theme) -> UIColor {
    return theme.color
  }
}
