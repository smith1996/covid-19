//
//  ViewController.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/24/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum State {
        case expanded
        case collapsed
    }
    
    //
    let cardHeight:CGFloat = 650//750
    let cardHandleAreaHeight:CGFloat = 65
    
    var cardVisible = false
    var visualEffectView:UIVisualEffectView!

    private var nextState: State {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    //
    
    var infectedMapViewController: InfectedMapViewController!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBottomSheet()
    }
    
    
    func addBottomSheet() {
        //
        infectedMapViewController = InfectedMapViewController(nibName: "InfectedMapViewController", bundle: nil)
        UIApplication.shared.keyWindow?.addSubview(infectedMapViewController.view)
        //self.addChild(infectedMapViewController)
        //self.view.addSubview(infectedMapViewController.view)
        
        infectedMapViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        infectedMapViewController.view.clipsToBounds = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(recognizer:)))
        //infectedMapViewController.testView.addGestureRecognizer(panGestureRecognizer)
        infectedMapViewController.view.addGestureRecognizer(panGestureRecognizer)
        //
    }
    
    
    @objc func handleGestureRecognizer(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: infectedMapViewController.view)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    private func startInteractiveTransition(state: State, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func animateTransitionIfNeeded(state: State, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.infectedMapViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.infectedMapViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
        }
    }
    
    private func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }

    private func continueInteractiveTransition(){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }


}
