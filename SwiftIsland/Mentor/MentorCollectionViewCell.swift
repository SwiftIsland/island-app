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
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
  override func prepareForReuse() {
    super.prepareForReuse()
    mentorImage.image = nil
    label.text = nil
    setupFonts()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupFonts()
    setupMetrics(with: traitCollection)
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
    let text: String = {
      var result = mentor.name
      if let country = mentor.country {
        result += "\n\(country)"
      }
      return result
    }()
    label.text = text
  }
  
  private func setupMetrics(with traits: UITraitCollection) {
    if traits.preferredContentSizeCategory.isAccessibilityCategory {
      imageWidthConstraint.constant = 240
    } else {
      imageWidthConstraint.constant = 136
    }
  }
  
  private func setupFonts() {
    let font = UIFont.systemFont(ofSize: 18.0, weight: .light)
    let metrics = UIFontMetrics(forTextStyle: .headline)
    let newFont = metrics.scaledFont(for: font)
    label.font = newFont
  }
}
