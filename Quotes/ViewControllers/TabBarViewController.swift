//
//  TabBarViewController.swift
//  quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    fileprivate let selectedLine: UIView = {
        let line: UIView = UIView()
        line.backgroundColor = UIColor.quotesPinkColor()
        return line
    }()
    
    var centerXLayoutConstraint: NSLayoutConstraint  = NSLayoutConstraint()

    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        // remove the top border of the tab bar
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
        
        tabBar.addSubview(selectedLine)
        
        // first item is selected by default
        setLineFrameWithIndex(index: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // first item is selected by default
        setLineFrameWithIndex(index: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.bringSubview(toFront: selectedLine)
    }
    
    // MARK: -  Private Methods
    
    fileprivate func setLineFrameWithIndex(index: Int) {
        // we can't modify constaints for UITabBar managed by a controller, so we won't use autoLayout with the animating line
        let tabBarItemWidth: CGFloat = UIScreen.main.bounds.width / 3.0
        let tabBarHeight: CGFloat = tabBar.bounds.height
        let selectedLineWidth: CGFloat = tabBarItemWidth - 50.0
        
        selectedLine.frame = CGRect(
            x: (tabBarItemWidth * CGFloat(index)) + (tabBarItemWidth/2.0) - (selectedLineWidth/2.0),
            y: tabBarHeight - UIWindow.safeAreaInsets().bottom,
            width: selectedLineWidth,
            height: 2.0
        )
    }
}

// MARK: -

extension TabBarViewController: UITabBarControllerDelegate {
   
    // MARK: - UITabBarControllerDelegate Methods
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let viewControllers = viewControllers else {
            return
        }
        
        if let tappedIndex = viewControllers.index(of: viewController) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.setLineFrameWithIndex(index: tappedIndex)
            }
        }
    }
}



