//
//  MentorCollectionViewCell.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-19.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class MentorCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var mentorImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!

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
    countryLabel.text = mentor.country
  }
}
