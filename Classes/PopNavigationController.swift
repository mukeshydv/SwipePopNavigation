//
//  PopNavigationController.swift
//  SwipePopDemo
//
//  Created by Mukesh on 03/07/18.
//  Copyright © 2018 BooEat. All rights reserved.
//

import UIKit

class PopNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    let transition = PopTransition()
    var duringAnimation = false
    var popRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        self.delegate = self
        addPanGesture()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated {
            duringAnimation = true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        duringAnimation = false
        popRecognizer.isEnabled = viewControllers.count > 1
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .pop) {
            return transition
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is PopTransition {
            return interactivePopTransition
        } else {
            return nil
        }
    }
    
    func addPanGesture() {
        popRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(recognizer:)))
        view.addGestureRecognizer(popRecognizer)
    }
    
    @objc func handlePanRecognizer(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            if viewControllers.count > 1 && !duringAnimation {
                interactivePopTransition = UIPercentDrivenInteractiveTransition()
                interactivePopTransition.completionCurve = .easeOut
                popViewController(animated: true)
            }
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
            let distance = translation.x > 0 ? translation.x / view.bounds.width : 0
            interactivePopTransition.update(distance)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            if recognizer.velocity(in: view).x > 0 {
                interactivePopTransition.finish()
            } else {
                interactivePopTransition.cancel()
                duringAnimation = false
            }
            interactivePopTransition = nil
        }
    }
}
