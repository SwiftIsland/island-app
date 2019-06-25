//
//  MentorCollectionView.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-06-19.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class MentorCollectionView: CardViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

  private let numberOfCellsPerRow: CGFloat = 2
  private let dataManager = DataManager.shared
  private var mentors: [Mentor] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchMentors()
    setupCollectionView()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    guard previousTraitCollection != nil else {
      return
    }
    collectionView?.collectionViewLayout.invalidateLayout()
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      
      if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 320, height: 400) // TODO: Not sure how to get a 'one icon per row' layout.
      } else {
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 136, height: 200)
      }
    }
  }
  
  private func fetchMentors() {
    loadingSpinner.startAnimating()
    dataManager.getMentors { result in
      self.loadingSpinner.stopAnimating()
      switch result {
      case .success(let mentors):
        self.mentors = mentors
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }

  private func showMentor(mentor: Mentor) {
    cardContent?.setup(withMentor: mentor)
    animateTransitionIfNeeded(state: .expanded, duration: defaultDuration)
  }
}

extension MentorCollectionView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let mentor = mentors[indexPath.item]
    showMentor(mentor: mentor)
  }
}

extension MentorCollectionView: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return mentors.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentorCollectionViewCell", for: indexPath) as? MentorCollectionViewCell else { return UICollectionViewCell() }
    let mentor = mentors[indexPath.item]
    cell.setup(withMentor: mentor)
    return cell
  }
}
