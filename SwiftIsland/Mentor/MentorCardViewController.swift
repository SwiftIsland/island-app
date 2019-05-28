//
//  MentorCardViewController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-05-27.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class MentorCardViewController: UIViewController {

  @IBOutlet weak var handleAreaView: UIView!
  @IBOutlet weak var mentorImageView: UIView!
  @IBOutlet weak var mentorImage: UIImageView!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!

  private let dataManager = DataManager.shared
  private var activity: Schedule.Activity?
  private var mentors: [Mentor] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchMentors()
  }

  func fetchMentors() {
    dataManager.getMentors { result in
      switch result {
      case .success(let mentors):
        self.mentors = mentors
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }

  func setup(withActivity activity: Schedule.Activity) {
    self.activity = activity

    titleLabel.text = activity.title
    descriptionLabel.text = activity.description
//    timeLabel.text = activity.datefrom
    locationLabel.text = activity.area

    if let mentor = mentors.first(where: { $0.id == activity.mentor }) {
      if let image = UIImage(named: mentor.image) {
        mentorImage.image = image
        mentorImageView.isHidden = false
      } else {
        mentorImageView.isHidden = true
      }
    } else {
      mentorImageView.isHidden = true
    }
  }
}
