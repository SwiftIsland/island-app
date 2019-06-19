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

    if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
      let cellDifference = flowLayout.itemSize.height / flowLayout.itemSize.width
      let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
      flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth * cellDifference)
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
