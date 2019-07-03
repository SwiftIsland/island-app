//
//  CardViewController.swift
//  SwiftIsland
//
//  Created by Paul Peelen on 2019-05-28.
//  Copyright © 2019 AppTrix AB. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

  enum CardState {
    case expanded
    case collapsed
  }

  var visualEffectView: UIVisualEffectView?
  let cardHeight: CGFloat = {
    let defaultHeight: CGFloat = 600
    let maxHeight = UIScreen.main.bounds.height * 0.85 // Just to add some spacing to the top, always.
    return min(defaultHeight, maxHeight)
  }()
  let defaultDuration = 0.6
  var cardVisible = false
  var nextState: CardState {
    return cardVisible ? .collapsed : .expanded
  }
  var runningAnimations = [UIViewPropertyAnimator]()
  var animationProgressWhenInterrupted: CGFloat = 0

  var cardContent: MentorCardViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCard()
  }

  func setupCard() {
    let visualEffectView = UIVisualEffectView()
    visualEffectView.frame = self.view.frame
    visualEffectView.isHidden = true
    view.addSubview(visualEffectView)
    self.visualEffectView = visualEffectView

    guard let viewController = UIStoryboard(name: "Mentor", bundle: nil)
      .instantiateViewController(withIdentifier: "MentorCardViewController") as? MentorCardViewController else { return }
    addChild(viewController)
    view.addSubview(viewController.view)

    viewController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.bounds.width, height: cardHeight)
    viewController.view.clipsToBounds = true
    cardContent = viewController

    setupGestures()
  }

  private func setupGestures() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognzier:)))
    tapGestureRecognizer.cancelsTouchesInView = false
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
    panGestureRecognizer.cancelsTouchesInView = false

    cardContent?.handleAreaView.addGestureRecognizer(tapGestureRecognizer)
    visualEffectView?.addGestureRecognizer(tapGestureRecognizer)
    cardContent?.handleAreaView.addGestureRecognizer(panGestureRecognizer)
  }

  @objc
  func handleCardTap(recognzier: UITapGestureRecognizer) {
    if case .ended = recognzier.state {
      animateTransitionIfNeeded(state: nextState, duration: defaultDuration)
    }
  }

  @objc
  func handleCardPan (recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      startInteractiveTransition(state: nextState, duration: defaultDuration)
    case .changed:
      let translation = recognizer.translation(in: cardContent?.handleAreaView)
      var fractionComplete = translation.y / cardHeight
      fractionComplete = cardVisible ? fractionComplete : -fractionComplete
      updateInteractiveTransition(fractionCompleted: fractionComplete)
    case .ended:
      continueInteractiveTransition()
    default:
      break
    }
  }

  func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
    if runningAnimations.isEmpty {
      let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
        self.cardContent?.view.frame.origin.y = self.view.frame.height
        if case .expanded = state {
          self.cardContent?.view.frame.origin.y -= self.cardHeight
        }
      }

      frameAnimator.addCompletion { _ in
        self.cardVisible = !self.cardVisible
        self.visualEffectView?.isHidden = !self.cardVisible
        self.runningAnimations.removeAll()
      }

      frameAnimator.startAnimation()
      runningAnimations.append(frameAnimator)

      let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
        let cornerRadius: CGFloat

        switch state {
        case .expanded:
          cornerRadius = 12
        case .collapsed:
          cornerRadius = 0
        }

        // Rounding all corners since using mask solution doesn't work well with animations
        self.cardContent?.handleAreaView.layer.cornerRadius = cornerRadius
      }

      cornerRadiusAnimator.startAnimation()
      runningAnimations.append(cornerRadiusAnimator)

      let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
        switch state {
        case .expanded:
          self.visualEffectView?.effect = UIBlurEffect(style: .dark)
          self.visualEffectView?.isHidden = false
        case .collapsed:
          self.visualEffectView?.effect = nil
        }
      }

      blurAnimator.startAnimation()
      runningAnimations.append(blurAnimator)
    }
  }

  func startInteractiveTransition(state: CardState, duration: TimeInterval) {
    if runningAnimations.isEmpty {
      animateTransitionIfNeeded(state: state, duration: duration)
    }
    for animator in runningAnimations {
      animator.pauseAnimation()
      animationProgressWhenInterrupted = animator.fractionComplete
    }
  }

  func updateInteractiveTransition(fractionCompleted: CGFloat) {
    for animator in runningAnimations {
      animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
    }
  }

  func continueInteractiveTransition () {
    for animator in runningAnimations {
      animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }
  }
}
