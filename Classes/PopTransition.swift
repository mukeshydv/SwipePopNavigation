//
//  PopTransition.swift
//  SwipePopDemo
//
//  Created by Mukesh on 03/07/18.
//  Copyright © 2018 BooEat. All rights reserved.
//

import UIKit

class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var toViewController: UIViewController?
    let config: PopNavigationControllerConfiguration
    
    init(_ config: PopNavigationControllerConfiguration) {
        self.config = config
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return config.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let toViewControllerXTransition = transitionContext.containerView.bounds.width * 0.3 * -1
        toViewController.view.bounds = transitionContext.containerView.bounds
        toViewController.view.center = transitionContext.containerView.center
        toViewController.view.transform = CGAffineTransform(translationX: toViewControllerXTransition, y: 0)
        
        let previousClipsToBounds = fromViewController.view.clipsToBounds
        fromViewController.view.clipsToBounds = false
        
        let dimmingView = UIView(frame: toViewController.view.bounds)
        let dimAmount: CGFloat = config.dimmingAlpha
        dimmingView.backgroundColor = UIColor(white: 0, alpha: dimAmount)
        toViewController.view.addSubview(dimmingView)
        
        let tabBarController = toViewController.tabBarController
        let navController = toViewController.navigationController
        let tabBar = tabBarController?.tabBar
        var shouldAddTabBarBackToTabBarController = false
        
        let tabBarControllerContainsToViewController = tabBarController?.viewControllers?.contains(toViewController) == true
        let tabBarControllerContainsNavController = tabBarController?.viewControllers?.contains(navController ?? UIViewController()) == true
        let isToViewControllerFirstInNavController = navController?.viewControllers.first == toViewController
        let shouldAnimateTabBar = config.shouldAnimateTabbar
        
        if shouldAnimateTabBar, let tabBar = tabBar, (tabBarControllerContainsToViewController || (isToViewControllerFirstInNavController && tabBarControllerContainsNavController)) {
            tabBar.layer.removeAllAnimations()
            
            var tabBarRect = tabBar.frame
            tabBarRect.origin.x = toViewController.view.bounds.origin.x
            tabBar.frame = tabBarRect
            
            toViewController.view.addSubview(tabBar)
            shouldAddTabBarBackToTabBarController = true
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = CGAffineTransform(translationX: toViewController.view.frame.size.width, y: 0)
            
            dimmingView.alpha = 0
        }) { (completed) in
            if shouldAddTabBarBackToTabBarController, let tabBar = tabBar {
                tabBarController?.view.addSubview(tabBar)
                
                var tabBarRect = tabBar.frame
                tabBarRect.origin.x = tabBarController?.view.bounds.origin.x ?? 0
                tabBar.frame = tabBarRect
            }
            
            dimmingView.removeFromSuperview()
            fromViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.clipsToBounds = previousClipsToBounds
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        self.toViewController = toViewController
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            toViewController?.view.transform = CGAffineTransform.identity
        }
    }
}
