//
//  ScheduleHeaderCell.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-21.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class ScheduleHeaderCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timelineLine: UIView!

  lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter.init()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .full
    return dateFormatter
  }()

  override func prepareForReuse() {
    super.prepareForReuse()
    dateLabel.text = ""
  }

  func setup(with schedule: Schedule, faded: Bool) {
    dateLabel.text = dateFormatter.string(from: schedule.date)
    timelineLine.alpha = faded ? Theme.fadedAlpha : 1
  }
}
