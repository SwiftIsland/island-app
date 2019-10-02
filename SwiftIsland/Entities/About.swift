//
//  About.swift
//  SwiftIsland
//
//  Created by misteu on 01.10.19.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

struct About: Codable {
  let appInfo: String
  let eventInfo: String
  let githubLink: String
  let contributors: [String]
}
