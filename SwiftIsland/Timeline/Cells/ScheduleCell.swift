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
  @IBOutlet weak var locationPill: DesignableView?
  @IBOutlet weak var timeLabel: UILabel?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    titleLabel.text = ""
    descriptionLabel.text = ""
    locationLabel.text = ""
    timeLabel?.text = ""
  }

  func setup(with activity: Schedule.Activity, faded: Bool) {
    titleLabel.text = activity.title
    descriptionLabel.text = activity.description
    timeLabel?.text = DateFormatter.dutchShortTime.string(from: activity.datefrom)
    locationLabel.text = activity.area
    locationPill?.isHidden = activity.area == nil
    contentView.alpha = faded ? Theme.fadedAlpha : 1
  }
}
