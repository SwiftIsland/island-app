//
//  ScheduleFooterCell.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-22.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class ScheduleFooterCell: UITableViewCell {

  @IBOutlet weak var timelineLine: UIView!

  func setup(faded: Bool) {
    selectionStyle = .none
    timelineLine.alpha = faded ? Theme.fadedAlpha : 1
  }
}
