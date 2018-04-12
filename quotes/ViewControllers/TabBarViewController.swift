//
//  TabBarViewController.swift
//  quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // remove the top border of the tab bar
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
    }
}
