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
  @IBOutlet weak var mentorButton: UIButton!

  var didSelectMentor: ((Mentor) -> Void)?
  private var mentor: Mentor?

  override func setup(with activity: Schedule.Activity) {
    super.setup(with: activity)

    if let mentorId = activity.mentor,
      let mentor = MentorManager.shared.mentors.first(where: { $0.id == mentorId }),
      let mentorImg = UIImage(named: mentor.image)
    {
      self.mentor = mentor
      mentorView.isHidden = false
      mentorButton.setImage(mentorImg, for: .normal)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    mentorView.isHidden = true
    mentorButton.setImage(nil, for: .normal)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  @IBAction func tapMentor(_ sender: Any) {
    if let mentor = mentor {
      didSelectMentor?(mentor)
    }
  }
}
