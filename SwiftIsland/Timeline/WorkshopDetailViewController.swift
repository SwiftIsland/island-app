import UIKit

class WorkshopDetailsViewController: UIViewController {

  static var StoryboardIdentifier: String = "WorkshopDetailsViewController"

  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var tagView: WorkshopTagView!
  @IBOutlet private var mentorView: WorkshopMentorView!
  @IBOutlet private var descriptionView: WorkshopDescriptionView!

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
    titleLabel.accessibilityHint = startsAtSpoken(activity.datefrom)

    configureArea(with: activity)
    configureMentor(with: activity)
    configureDescription(with: activity)
  }

  private func configureArea(with activity: Schedule.Activity) {
    if let area = activity.area,
      area.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
      tagView.isHidden = false
      tagView.text = area
    } else {
      tagView.isHidden = true
    }
  }

  private func configureMentor(with activity: Schedule.Activity) {
    let mentors = MentorManager.shared.mentors
    if let mentorId = activity.mentor,
      let mentor = mentors.first(where: { $0.id == mentorId }) {
      mentorView.isHidden = false
      mentorView.mentor = mentor
    } else {
      mentorView.isHidden = true
    }
  }

  private func configureDescription(with activity: Schedule.Activity) {
    if activity.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
      descriptionView.isHidden = false
      descriptionView.text = activity.description
    } else {
      descriptionView.isHidden = true
    }

    navigationItem.title = DateFormatter.dutchShortTime.string(from: activity.datefrom)
    navigationItem.accessibilityLabel = startsAtSpoken(activity.datefrom)
  }
}

class WorkshopTagView: UIView {
  @IBOutlet var tagLabel: UILabel!

  var text: String? {
    didSet {
      guard let text = text, text.isEmpty == false else {
        return
      }
      tagLabel.text = text

      isAccessibilityElement = true
      accessibilityLabel = "Location: \(text)."
    }
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

      isAccessibilityElement = true
      accessibilityLabel = "Mentor: \(mentor.name)."
    }
  }
}

class WorkshopDescriptionView: UIView {
  @IBOutlet var descriptionLabel: UILabel!

  var text: String? {
    didSet {
      guard let text = text, text.isEmpty == false else {
        return
      }
      descriptionLabel.text = text

      isAccessibilityElement = true
      accessibilityLabel = text
    }
  }
}

private func startsAtSpoken(_ date: Date) -> String {
  return "Starts at \(DateFormatter.dutchShortTimeSpoken.string(from: date))."
}
