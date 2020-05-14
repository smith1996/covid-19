//
//  BottomSheet.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/26/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

protocol BottomSheetDelegate: class {
    associatedtype EnumType
    var bottomViewHeight: CGFloat { get set }
    var isVisible: Bool { get set }
    var runningAnimations: [UIViewPropertyAnimator] { get set }
    var animationProgressWhenInterrupted: CGFloat { get set }
    //
    func startInteractiveTransition(state: EnumType, duration: TimeInterval)
    func animateTransitionIfNeeded(state: EnumType, duration: TimeInterval)
    func updateInteractiveTransition(fractionCompleted: CGFloat)
    func continueInteractiveTransition()
}

class BottomSheet: BottomSheetDelegate {
    
    internal enum State {
        case expanded
        case collapsed
    }
    
    typealias EnumType = State
    
    var bottomViewHeight: CGFloat = 0.0
    
    var isVisible: Bool = false
    
    var runningAnimations: [UIViewPropertyAnimator] = [UIViewPropertyAnimator]()
    
    var animationProgressWhenInterrupted: CGFloat = 0.0
    
    //
    var bottomView: UIView
    var mainView: UIView

    init(_ view: UIView, presentationView: UIView) {
        bottomView = view
        mainView = presentationView
        bottomViewHeight = bottomView.frame.height
    }
    
    func startInteractiveTransition(state: BottomSheet.State, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func animateTransitionIfNeeded(state: BottomSheet.State, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.bottomView.frame.origin.y = self.mainView.frame.height - self.bottomViewHeight
                case .collapsed:
                    self.bottomView.frame.origin.y = self.mainView.frame.height - Constant.heightForPresentationView
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.isVisible = !self.isVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
}
