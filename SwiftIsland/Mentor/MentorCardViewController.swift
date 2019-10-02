//
//  MentorCardViewController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-05-27.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class MentorCardViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var handleAreaView: UIView!
  @IBOutlet weak var mentorImageView: UIView!
  @IBOutlet weak var mentorImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var socialTwitter: UIButton!
  @IBOutlet weak var socialWeb: UIButton!
  @IBOutlet weak var dragHandleImageSpacer: NSLayoutConstraint!
  @IBOutlet weak var twitterWidthConstraint: NSLayoutConstraint!

  private var mentor: Mentor?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Only enable the spacer on small screens.
    if UIScreen.main.bounds.width > 320.0 {
      dragHandleImageSpacer.isActive = false
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {

      let adjustedWidth = UIFontMetrics(forTextStyle: .body).scaledValue(for: 36.0)
      twitterWidthConstraint.constant = adjustedWidth
    }
  }

  func setup(withMentor mentor: Mentor) {
    self.mentor = mentor

    scrollView.setContentOffset(.zero, animated: false)

    titleLabel.text = mentor.name
    descriptionLabel.text = mentor.bio

    if let image = UIImage(named: mentor.image) {
      mentorImage.image = image
      mentorImageView.isHidden = false
    } else {
      mentorImageView.isHidden = true
    }

    socialTwitter.alpha = mentor.twitter != nil ? 1 : 0.3
    socialTwitter.isUserInteractionEnabled = mentor.twitter != nil
    socialWeb.alpha = mentor.web != nil ? 1 : 0.3
    socialWeb.isUserInteractionEnabled = mentor.twitter != nil
  }

  @IBAction func openTwitterUrl(_ sender: UIButton) {
    guard let twitterUrl = mentor?.twitter else { return }
    UIApplication.shared.open(twitterUrl)
  }

  @IBAction func openWeb(_ sender: UIButton) {
    guard let webUrl = mentor?.web else { return }
    UIApplication.shared.open(webUrl)
  }
}
