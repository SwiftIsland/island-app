//
//  About.swift
//  SwiftIsland
//
//  Created by misteu on 01.10.19.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

struct About: Codable {
  let appInfo: AppInfo
  let eventInfo: String
  let githubLink: String
  let contributors: [String]
}

struct AppInfo: Codable {
  let appName: String
  let appVersion: String
  let appDescription: String
  let organisers: [String]
}
