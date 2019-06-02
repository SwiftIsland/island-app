//
//  Schedule.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-04-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

struct Schedule: Codable {

  let date: Date
  let title: String
  let activities: [Activity]

  struct Activity: Codable {
    let id: String
    let title: String
    let description: String
    let datefrom: Date
    let dateto: Date
    let area: String?
    let mentor: Int?
    let concurrent: [Activity]?
  }
}
