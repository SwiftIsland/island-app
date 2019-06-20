//
//  NetworkReachability.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-20.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import Foundation
import Network

enum NetworkStatus {
  case reachable
  case unreachable
}

class NetworkReachability {

  private let pathMonitor: NWPathMonitor
  private var lastPath: NWPath?
  var didChangeConnectivity: ((NetworkStatus) -> Void)?

  init() {
    pathMonitor = NWPathMonitor()
    pathMonitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        self.lastPath = path
        if path.status == NWPath.Status.satisfied {
          self.didChangeConnectivity?(.reachable)
        } else {
          self.didChangeConnectivity?(.unreachable)
        }
      }
    }
    pathMonitor.start(queue: DispatchQueue.global(qos: .background))
  }

  func stop() {
    pathMonitor.cancel()
  }
}
