//
//  Mentor.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-05-28.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation

struct Mentor: Codable {
  let id: Int
  let name: String
  let image: String
  let bio: String
  let twitter: URL?
  let web: URL?
}
