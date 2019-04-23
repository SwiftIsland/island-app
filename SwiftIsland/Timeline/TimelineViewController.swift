//
//  TimelineViewController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-10.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

  private let dataManager = DataManager.shared
  private var schedule: [Schedule] = []

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchSchedule()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 110
    tableView.sectionHeaderHeight = 39
  }

  func fetchSchedule() {
    dataManager.getSchedule { result in
      switch result {
      case .success(let schedule):
        self.schedule = schedule
        self.tableView.reloadData()
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }
}

extension TimelineViewController: UITableViewDelegate {

}

extension TimelineViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return schedule.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return schedule[section].activities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as? ScheduleCell else { return UITableViewCell() }
    let activity = schedule[indexPath.section].activities[indexPath.row]
    cell.setup(with: activity)

    return cell
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
