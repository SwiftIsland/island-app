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
    setupFonts()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupFonts()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    guard previousTraitCollection != nil else {
      return
    }
    setupFonts()
  }
  
  func setup(withMentor mentor: Mentor) {
    if let image = UIImage(named: mentor.image) {
      mentorImage.image = image
    }
    nameLabel.text = mentor.name

    if let country = mentor.country {
      countryLabel.text = country
    } else {
      countryLabel.text = ""
    }
  }
  
  private func setupFonts() {
    let font = UIFont.systemFont(ofSize: 18.0, weight: .light)
    let metrics = UIFontMetrics(forTextStyle: .headline)
    let newFont = metrics.scaledFont(for: font)
    nameLabel.font = newFont
  }
}
