//
//  FeedViewController.swift
//  quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate var titleLabel: UILabel {
        let label: UILabel = UILabel()
        label.text = "Quotes"
        label.font = UIFont.extraBoldFont(size: 20.0)
        label.textColor = UIColor.quotesPinkColor()
        return label
    }
    
    fileprivate var searchButton: UIButton {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "SearchIcon"), for: UIControlState.normal)
        button.sizeToFit()
        return button
    }
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationController = navigationController {
            navigationController.navigationBar.topItem?.titleView = titleLabel
            navigationController.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(customView: searchButton), animated: false)
        }
    }

}

