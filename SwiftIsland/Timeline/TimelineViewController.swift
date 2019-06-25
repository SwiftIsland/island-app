//
//  TimelineViewController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-10.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class TimelineViewController: CardViewController {

  private let dataManager = DataManager.shared
  private var schedule: [Schedule] = []
  private var activities: [[Schedule.Activity]] = []
  private let networkRechability: NetworkReachability = NetworkReachability()
  private let userDefaults: UserDefaults = UserDefaults.standard

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.isHidden = true
    }
  }
  @IBOutlet weak var countdownContainer: UIView! {
    didSet {
      countdownContainer.isHidden = true
    }
  }
  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

  override func loadView() {
    super.loadView()

    _ = MentorManager.shared.mentors // Todo: Make a more elegant solution for this. Need to access this here for now so it is ready for the table later

    networkRechability.didChangeConnectivity = { [weak self] status in
      guard let self = self else { return }
      let userDefaultsKey = "showNetworkError"

      let shouldShowAlert = self.userDefaults.object(forKey: userDefaultsKey) != nil ? self.userDefaults.bool(forKey: userDefaultsKey) : true
      if case .unreachable = status, shouldShowAlert {
        // swiftlint:disable line_length
        let alert = UIAlertController(
          title: "Where did you go?",
          message: "It seems that there is no network connection. The first time the app launches it'll download the schedule, bungalow locations and mentor information. After that, it can be used offline... but that'll mean you won't get any updates, which makes the app sad :(",
          preferredStyle: .alert)
        // swiftlint:enable line_length
        alert.addAction(UIAlertAction(title: "Don't show again", style: .default, handler: { (_) in
          self.userDefaults.set(false, forKey: userDefaultsKey)
        }))
        alert.addAction(UIAlertAction(title: "Thanks", style: .cancel, handler: nil))
        self.present(alert, animated: true)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 110
    tableView.sectionHeaderHeight = 39
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchSchedule()
  }

  func fetchSchedule() {
    loadingSpinner.startAnimating()
    dataManager.getSchedule { result in
      self.loadingSpinner.stopAnimating()
      switch result {
      case .success(let schedule):
        self.countdownContainer.isHidden = true
        self.tableView.isHidden = false
        var activities: [[Schedule.Activity]] = []

        for day in schedule {
          var dayItems: [Schedule.Activity] = []

          for activity in day.activities {
            dayItems.append(activity)

            if let subItems = activity.concurrent {
              dayItems.append(contentsOf: subItems)
            }
          }
          activities.append(dayItems)
        }

        self.activities = activities
        self.schedule = schedule
        self.tableView.reloadData()
      case .failure(let error):
        self.countdownContainer.isHidden = false
        if case .notYetAvailable = error {
          debugPrint("The schedule is not yet released.")
        } else {
          debugPrint("Another error occured! Error: \(error)")
        }
      }
    }
  }
}

private extension TimelineViewController {

  func showActivity(activity: Schedule.Activity) {
    debugPrint("Show activity \(activity)")
  }
}

extension TimelineViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let activity = activities[indexPath.section][indexPath.row]
    showActivity(activity: activity)
  }
}

extension TimelineViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return schedule.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activities[section].count
//    return schedule[section].activities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let activity = activities[indexPath.section][indexPath.row]
    let isConcurrent = schedule[indexPath.section].activities.first(where: { $0.id == activity.id }) == nil

    let activityCell: ScheduleCell
    if isConcurrent {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConcurrentCell") as? ConcurrentCell else { return UITableViewCell() }
      activityCell = cell

      cell.didSelectMentor = { mentor in
        self.cardContent?.setup(withMentor: mentor)
        self.animateTransitionIfNeeded(state: .expanded, duration: 0.6)
      }
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as? ScheduleCell else { return UITableViewCell() }
      activityCell = cell
    }

    activityCell.setup(with: activity)
    return activityCell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleHeaderCell") as? ScheduleHeaderCell else { return nil }
    let day = schedule[section]
    cell.setup(with: day)
    return cell
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return tableView.dequeueReusableCell(withIdentifier: "ScheduleFooterCell")
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 40
  }
}
