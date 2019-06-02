//
//  MentorCell.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-05-28.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class MentorCell: UITableViewCell {

  @IBOutlet weak var mentorImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    mentorImage.image = nil
    nameLabel.text = nil
  }

  func setup(withMentor mentor: Mentor) {
    if let image = UIImage(named: mentor.image) {
      mentorImage.image = image
    }
    nameLabel.text = mentor.name
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
