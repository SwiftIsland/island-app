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

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var countdownContainer: UIView!
  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchSchedule()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 110
    tableView.sectionHeaderHeight = 39
  }

  func fetchSchedule() {
    loadingSpinner.startAnimating()
    dataManager.getSchedule { result in
      self.loadingSpinner.stopAnimating()
      switch result {
      case .success(let schedule):
        self.countdownContainer.isHidden = true
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
        if case .notYetAvailable = error {
          debugPrint("The schedule is not yet released.")
        } else {
          debugPrint("Another error occured!")
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
