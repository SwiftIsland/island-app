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
  private var about: About? {
    didSet {
      updateLabels()
    }
  }
  
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var appVersionLabel: UILabel!
  @IBOutlet weak var appDescriptionLabel: UILabel!
  @IBOutlet weak var appOrganisersLabel: UILabel!
  @IBOutlet weak var eventInfoLabel: UILabel!
  @IBOutlet weak var githubLinkButton: UIButton!
  @IBOutlet weak var contributorsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadDummyAboutData()
  }
  
  private func loadDummyAboutData() {
    
    // TODO: remove and include cacheManager etc.
    guard let dummyData = TestDataManager().getLocalTestAsset(forPath: "About_valid.json") else { return }
    about = try? JSONDecoder().decode(About.self, from: dummyData)
  }
  
  private func updateLabels() {
    guard let about = about else { return }
    appNameLabel.text = about.appInfo.appName
    appVersionLabel.text = "Version: \( about.appInfo.appVersion)"
    appDescriptionLabel.text = "About the app:\n\(about.appInfo.appDescription)"
    appOrganisersLabel.text = "Organisers of github repository:\n\( about.appInfo.organisers.joined(separator: ", "))"
    eventInfoLabel.text = "About the event:\n\(about.eventInfo)"
  githubLinkButton.setTitle(about.githubLink, for: .normal)
    contributorsLabel.text = "Contributors: \( about.contributors.joined(separator: ", "))"
  }
  
  @IBAction func openGithubUrl(_ sender: Any) {
    // e.g. open in Safari
    print("open safari")
  }
  
  
}
