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
  let latestAppVersion: String
  let appDescription: String
  let organisers: [Organiser]
}

struct Organiser: Codable {
  let handle: String
  let name: String
  let twitter: String
  let url: String
  let linkedin: String
}
