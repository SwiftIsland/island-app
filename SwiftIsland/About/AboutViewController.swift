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
      activityIndicator.isHidden = true
    }
  }
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var appVersionLabel: UILabel!
  @IBOutlet weak var appDescriptionLabel: UILabel!
  @IBOutlet weak var appOrganisersLabel: UILabel!
  @IBOutlet weak var eventInfoLabel: UILabel!
  @IBOutlet weak var githubLinkButton: UIButton!
  @IBOutlet weak var contributorsLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.isHidden = true
    fetchAbout()
  }
    
  private func updateLabels() {
    guard let about = about else { return }
    appNameLabel.text = about.appInfo.appName
    appVersionLabel.text = "Version: \( about.appInfo.latestAppVersion)"
    appDescriptionLabel.text = "About the app:\n\(about.appInfo.appDescription)"
    var organisers = [String]()
    about.appInfo.organisers.forEach { (organiser) in
      organisers.append(organiser.handle)
    }
    appOrganisersLabel.text = "Organisers of github repository:\n\(organisers.joined(separator: ", "))"
    eventInfoLabel.text = "About the event:\n\(about.eventInfo)"
    githubLinkButton.setTitle(about.githubLink, for: .normal)
    contributorsLabel.text = "Contributors: \( about.contributors.joined(separator: ", "))"
    activityIndicator.isHidden = true
    scrollView.isHidden = false
  }
  
  @IBAction func openGithubUrl(_ sender: Any) {
    if let about = about, let url = URL(string: about.githubLink) {
        UIApplication.shared.open(url)
    }
  }
  
  func fetchAbout() {
    dataManager.get(ofType: .about) { (result: Result<About, DataErrors>) -> Void in
      switch result {
      case .success(let about):
        self.about = about
      case .failure(let error):
        self.scrollView.isHidden = true
        self.activityIndicator.isHidden = true
        debugPrint(error.localizedDescription)
      }
    }
  }
}
