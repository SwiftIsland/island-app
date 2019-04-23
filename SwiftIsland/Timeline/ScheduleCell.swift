//
//  ScheduleCell.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-21.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!

  lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter.init()
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .none
    return dateFormatter
  }()

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    titleLabel.text = ""
    descriptionLabel.text = ""
    locationLabel.text = ""
    timeLabel.text = ""
  }

  func setup(with activity: Schedule.Activity) {
    titleLabel.text = activity.title
    descriptionLabel.text = activity.description
    locationLabel.text = activity.area
    timeLabel.text = dateFormatter.string(from: activity.datefrom)
  }
}
