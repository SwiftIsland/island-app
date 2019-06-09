//
//  MentorManager.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-02.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

class MentorManager {

  static let shared = MentorManager()

  private let dataManager: DataManaging
  private(set) var mentors: [Mentor] = []

  init(dataManager: DataManaging = DataManager.shared) {
    self.dataManager = dataManager
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
}
