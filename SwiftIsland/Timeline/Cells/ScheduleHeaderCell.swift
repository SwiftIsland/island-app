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

  func setup(with schedule: Schedule) {
    dateLabel.text = dateFormatter.string(from: schedule.date)
  }
}
