//
//  QuoteReviewViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class QuoteReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let reviewNavigationBar: QuotesNavigationBar = QuotesNavigationBar()
    
    fileprivate let backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(UIColor.quotesPinkColor(), for: UIControlState.normal)
        button.setTitle("Back", for: UIControlState.normal)
        button.titleLabel?.font = UIFont.extraBoldFont(size: 14.0)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "REVIEW"
        label.font = UIFont.extraBoldFont(size: 20.0)
        label.textColor = UIColor.quotesPinkColor()
        return label
    }()
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.titleView = titleLabel
        
        backButton.addTarget(
            self,
            action: #selector(QuoteReviewViewController.backButtonTouched(_:)),
            for: UIControlEvents.touchUpInside
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationController = navigationController,
            let navigationBar = navigationController.navigationBar as? QuotesNavigationBar {
            navigationBar.setNavigationBar(title: "REVIEW", tint: QuotesNavigationBarTint.Light)
            navigationBar.topItem?.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: false)
        }
    }
    
    // MARK: - Action Methods
    
    @objc func backButtonTouched(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}
