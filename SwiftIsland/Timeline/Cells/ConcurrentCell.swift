//
//  ConcurrentCell.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-02.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class ConcurrentCell: ScheduleCell {

  @IBOutlet weak var mentorView: UIView!
  @IBOutlet weak var mentorImage: UIImageView!

  override func setup(with activity: Schedule.Activity) {
    super.setup(with: activity)

    if let mentorId = activity.mentor,
      let mentor = MentorManager.shared.mentors.first(where: { $0.id == mentorId }),
      let mentorImg = UIImage(named: mentor.image)
    {
      mentorView.isHidden = false
      mentorImage.image = mentorImg
    }

    debugPrint("NOT YET IMPLEMENTED!")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    mentorView.isHidden = true
    mentorImage.image = nil
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
