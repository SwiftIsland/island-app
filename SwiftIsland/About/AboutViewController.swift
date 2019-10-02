//
//  AboutViewController.swift
//  SwiftIsland
//
//  Created by misteu on 01.10.19.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
  
  private let dataManager = DataManager.shared
  private var about: About?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
  }
}
