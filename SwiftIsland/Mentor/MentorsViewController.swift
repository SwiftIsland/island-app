//
//  MentorsViewController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-05-28.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class MentorsViewController: CardViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

  private let dataManager = DataManager.shared
  private var mentors: [Mentor] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchMentors()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 110
    tableView.sectionHeaderHeight = 0
  }

  private func fetchMentors() {
    loadingSpinner.startAnimating()
    dataManager.getMentors { result in
      self.loadingSpinner.stopAnimating()
      switch result {
      case .success(let mentors):
        self.mentors = mentors
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }

  private func showMentor(mentor: Mentor) {
    cardContent?.setup(withMentor: mentor)
    animateTransitionIfNeeded(state: .expanded, duration: defaultDuration)
  }
}

extension MentorsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let mentor = mentors[indexPath.row]
    showMentor(mentor: mentor)
  }
}

extension MentorsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mentors.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentorCell") as? MentorCell else { return UITableViewCell() }
    let mentor = mentors[indexPath.row]
    cell.setup(withMentor: mentor)
    return cell
  }
}
