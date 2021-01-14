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
  private var shouldScrollToActiveIndex = true
  private var indexPathOfActiveItem: IndexPath? {
    didSet {
      scrollToActiveIndex()
    }
  }

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

    dataManager.get(ofType: .schedule) { (result: Result<[Schedule], DataErrors>) in
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
        self.setCurrentActiveItem()
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

// MARK: Displaying activities
private extension TimelineViewController {

  func showActivity(activity: Schedule.Activity) {
    debugPrint("Show activity \(activity)")
    guard let viewController = UIStoryboard(name: "Timeline", bundle: nil)
      .instantiateViewController(withIdentifier: ActivityDetailsViewController.StoryboardIdentifier) as? ActivityDetailsViewController else {
        assertionFailure("We expect a view controller here.")
        return
    }
    viewController.activity = activity
    shouldScrollToActiveIndex = false
    navigationController?.pushViewController(viewController, animated: true)
  }

  func findCurrentActiveItem() -> Schedule.Activity? {
    let currentDate = Date() // Date(timeIntervalSince1970: 1562172780) // For testing purposes
    let allActivities = activities.reduce([], +).sorted { $0.datefrom > $1.datefrom }
    return allActivities.first { currentDate.compare($0.datefrom) == .orderedDescending || currentDate.compare($0.datefrom) == .orderedSame }
  }

  func setCurrentActiveItem() {
    let currentItem = findCurrentActiveItem()

    var section = 0
    var indexPath: IndexPath?
    for activityDay in activities {
      if let index = activityDay.firstIndex(where: { $0 == currentItem}) {
        indexPath = IndexPath(row: index, section: section)
        continue
      }
      section += 1
    }

    indexPathOfActiveItem = indexPath
  }

  func scrollToActiveIndex() {
    defer {
      shouldScrollToActiveIndex = true
    }
    guard shouldScrollToActiveIndex, let indexPath = indexPathOfActiveItem else { return }
    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
  }

  func shouldFade(cellIndexPath: IndexPath) -> Bool {
    guard let currentItem = indexPathOfActiveItem else { return false }

    if cellIndexPath.section == currentItem.section {
      return cellIndexPath.row < currentItem.row
    } else {
      return cellIndexPath.section < currentItem.section
    }
  }
}

// MARK: UITableViewDelegate
extension TimelineViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rowCount = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
    guard indexPath.row > 0, indexPath.row < rowCount - 1 else { return }
    let adjustedIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
    let activity = activities[adjustedIndexPath.section][adjustedIndexPath.row]
    showActivity(activity: activity)
  }
}

// MARK: UITableViewDataSource
extension TimelineViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return schedule.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activities[section].count + 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let rowCount = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
    // We avoid using a section header and footer view, opting for actual cells instead.
    // This way, we can avoid auto layout complications when self-sizing.
    switch indexPath.row {
    case 0: // Header
      return headerCell(for: indexPath.section)
    case 1..<rowCount-1: // Schedule
      let adjustedIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
      return scheduleCell(for: adjustedIndexPath)
    case rowCount-1: // Footer
      return footerCell(for: indexPath.section)
    default:
      assertionFailure("No row available.")
      return UITableViewCell()
    }
  }

  private func scheduleCell(for indexPath: IndexPath) -> UITableViewCell {
    let activity = activities[indexPath.section][indexPath.row]
    let isConcurrent = schedule[indexPath.section].activities.first(where: { $0.id == activity.id }) == nil

    let activityCell: ScheduleCell
    if isConcurrent {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConcurrentCell") as? ConcurrentCell else {
        assertionFailure("This should always return a cell.")
        return UITableViewCell()
      }
      activityCell = cell

      cell.didSelectMentor = { mentor in
        self.cardContent?.setup(withMentor: mentor)
        self.animateTransitionIfNeeded(state: .expanded, duration: 0.6)
      }
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as? ScheduleCell else {
        assertionFailure("This should always return a cell.")
        return UITableViewCell()
      }
      activityCell = cell
    }

    activityCell.setup(with: activity, faded: shouldFade(cellIndexPath: indexPath))
    return activityCell
  }

  private func headerCell(for section: Int) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleHeaderCell") as? ScheduleHeaderCell else {
      assertionFailure("This should always return a cell.")
      return UITableViewCell()
    }

    let day = schedule[section]
    cell.setup(with: day, faded: shouldFade(cellIndexPath: IndexPath(row: 0, section: section)))
    return cell
  }

  func footerCell(for section: Int) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFooterCell") as? ScheduleFooterCell else {
      assertionFailure("This should always return a cell.")
      return UITableViewCell()
    }
    cell.setup(faded: shouldFade(cellIndexPath: IndexPath(row: activities[section].count-1, section: section)))
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
