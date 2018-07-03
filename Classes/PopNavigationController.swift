//
//  PopNavigationController.swift
//  SwipePopDemo
//
//  Created by Mukesh on 03/07/18.
//  Copyright © 2018 BooEat. All rights reserved.
//

import UIKit

class PopNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    private var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    private let config = PopNavigationControllerConfiguration()
    private lazy var transition = PopTransition(config)
    private var duringAnimation = false
    private var popRecognizer: UIPanGestureRecognizer!
    
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
        popRecognizer.delegate = self
        view.addGestureRecognizer(popRecognizer)
    }
    
    @objc func handlePanRecognizer(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            if viewControllers.count > 1 && !duringAnimation {
                interactivePopTransition = UIPercentDrivenInteractiveTransition()
                interactivePopTransition?.completionCurve = .easeOut
                popViewController(animated: true)
            }
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
            let distance = translation.x > 0 ? translation.x / view.bounds.width : 0
            interactivePopTransition?.update(distance)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            if recognizer.velocity(in: view).x > 0 {
                interactivePopTransition?.finish()
            } else {
                interactivePopTransition?.cancel()
                duringAnimation = false
            }
            interactivePopTransition = nil
        }
    }
}

extension PopNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count > 1, config.isEnabled else { return false }
        
        if popRecognizer == gestureRecognizer, let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            // To allow panning in only right direction...
            let velocity = panGesture.velocity(in: view)
            return velocity.x > abs(velocity.y)
        }
        
        return true
    }
}

extension PopNavigationController {
    
    @IBInspectable public var isEnabled: Bool {
        set {
            config.isEnabled = newValue
        }
        get {
            return config.isEnabled
        }
    }
    
    @IBInspectable public var transitionDuration: CGFloat {
        set {
            config.transitionDuration = TimeInterval(newValue)
        }
        get {
            return CGFloat(config.transitionDuration)
        }
    }
    
    @IBInspectable public var dimmingAlpha: CGFloat {
        set {
            config.dimmingAlpha = newValue
        }
        get {
            return config.dimmingAlpha
        }
    }
    
    @IBInspectable public var shouldAnimateTabbar: Bool {
        set {
            config.shouldAnimateTabbar = newValue
        }
        get {
            return config.shouldAnimateTabbar
        }
    }
}

class PopNavigationControllerConfiguration {
    var transitionDuration: TimeInterval = 0.3
    var dimmingAlpha: CGFloat = 0.1
    var shouldAnimateTabbar: Bool = true
    var isEnabled = true
    fileprivate init() { }
}
