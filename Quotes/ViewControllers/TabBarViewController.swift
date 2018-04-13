//
//  TabBarViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    static let tabBarHeight: CGFloat = 50.0
    
    fileprivate let selectedLine: UIView = {
        let line: UIView = UIView()
        line.backgroundColor = UIColor.quotesPinkColor()
        return line
    }()
    
    fileprivate let quotesButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "quoteProcessIcon"), for: UIControlState.normal)
        button.backgroundColor = UIColor.quotesPinkColor()
        return button
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
        
        // setup quoteButton
        view.addSubview(quotesButton)
        
        quotesButton.addTarget(
            self,
            action: #selector(TabBarViewController.quotesButtonTouched(_:)),
            for: UIControlEvents.touchUpInside
        )

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
        
        // keyWindow is nil until the view appears since we're using storyboards, so let's set the quotesButton frame here
        let buttonSize: CGFloat = 60.0
        quotesButton.frame = CGRect(
            x: UIScreen.main.bounds.width/2.0 - buttonSize/2.0,
            y: UIScreen.main.bounds.height - UIWindow.safeAreaInsets().bottom - buttonSize,
            width: buttonSize,
            height: buttonSize
        )
        quotesButton.layer.cornerRadius = buttonSize/2.0
    }
    
    // MARK: -  Action Methods
    
    @objc func quotesButtonTouched(_ sender: AnyObject) {
        performSegue(withIdentifier: "QuotesViewControllerSegue", sender: self)
    }
    
    // MARK: -  Private Methods
    
    fileprivate func setLineFrameWithIndex(index: Int) {
        // we can't modify constaints for UITabBar managed by a controller, so we won't use autoLayout with the animating line
        let tabBarItemWidth: CGFloat = UIScreen.main.bounds.width / 3.0
        let tabBarHeight: CGFloat = tabBar.bounds.height
        let selectedLineWidth: CGFloat = tabBarItemWidth - 50.0
        
        selectedLine.frame = CGRect(
            x: (tabBarItemWidth * CGFloat(index)) + (tabBarItemWidth/2.0) - (selectedLineWidth/2.0),
            y: tabBarHeight - UIWindow.safeAreaInsets().bottom - 2.0,
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // so we don't have to create a custom tab bar, let's disable the quotesViewController since we'll be displaying
        // a modal instead of presenting a vc in a tab
        if viewController.isKind(of: QuotesViewController.self) {
            return false
        }
        return true
    }
}



