import UIKit

class WorkshopDetailsViewController: UIViewController {

  static var StoryboardIdentifier: String = "WorkshopDetailsViewController"

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet fileprivate var mentorView: WorkshopMentorView!
  @IBOutlet fileprivate var descriptionView: WorkshopDescriptionView!

  var activity: Schedule.Activity? {
    didSet {
      configure(with: activity)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configure(with: activity)
  }

  func configure(with activity: Schedule.Activity?) {
    guard view != nil, let activity = activity else {
      return
    }
    titleLabel.text = activity.title

    let mentors = MentorManager.shared.mentors
    if let mentorId = activity.mentor,
      let mentor = mentors.first(where: { $0.id == mentorId }) {
      mentorView.isHidden = false
      mentorView.mentor = mentor
    } else {
      mentorView.isHidden = true
    }

    if activity.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
      descriptionView.isHidden = false
      descriptionView.text = activity.description
    } else {
      descriptionView.isHidden = true
    }

    navigationItem.title = DateFormatter.dutchShortTime.string(from: activity.datefrom)
  }
}

class WorkshopMentorView: UIView {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var avatarImageView: UIImageView!

  var mentor: Mentor? {
    didSet {
      guard let mentor = mentor else {
        return
      }
      nameLabel.text = mentor.name
      avatarImageView.image = UIImage(named: mentor.image)
    }
  }
}

class WorkshopDescriptionView: UIView {
  @IBOutlet var descriptionLabel: UILabel!

  var text: String? {
    didSet {
      descriptionLabel.text = text
    }
  }
}
