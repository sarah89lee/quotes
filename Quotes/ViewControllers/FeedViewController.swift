//
//  FeedViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    fileprivate let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Quotes"
        label.font = UIFont.extraBoldFont(size: 20.0)
        label.textColor = UIColor.quotesPinkColor()
        return label
    }()
    
    fileprivate let searchButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "SearchIcon"), for: UIControlState.normal)
        button.sizeToFit()
        return button
    }()
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.addTarget(
            self,
            action: #selector(FeedViewController.searchButtonTouched(_:)),
            for: UIControlEvents.touchUpInside
        )
        
        // set the custom navigationItem title and right bar button
        if let navigationController = navigationController {
            navigationController.navigationBar.topItem?.titleView = titleLabel
            navigationController.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(customView: searchButton), animated: false)
        }
        
        // set the custom font and color of the search bar cancel button
        let attributes = [
            NSAttributedStringKey.foregroundColor : UIColor.quotesPinkColor(),
            NSAttributedStringKey.font : UIFont.extraBoldFont(size: 14.0)
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: UIControlState.normal)
        
        // change searchBar font
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.black
        textFieldInsideUISearchBar?.font = UIFont.mediumFont(size: 12.0)
    }
    
    // MARK: - Action Methods
    
    @objc func searchButtonTouched(_ sender: AnyObject) {
        guard let navigationController = navigationController else {
            return
        }
        
        guard let topItem = navigationController.navigationBar.topItem else {
            return
        }
        
        // animate the searchButton away and display the searchBar
        UIView.animate(withDuration: 0.2, animations: {
            navigationController.navigationBar.topItem?.setRightBarButton(nil, animated: false)
        }) { [weak self] (finished) in
            self?.searchBar.alpha = 1.0
            self?.searchBar.setImage(
                UIImage(named: "SearchIcon"),
                for: UISearchBarIcon.search,
                state: UIControlState.normal
            )
            self?.searchBar.delegate = self
            self?.searchBar.placeholder = "Search"
            self?.searchBar.setShowsCancelButton(true, animated: true)
            self?.searchBar.becomeFirstResponder()
            
            topItem.titleView = self?.searchBar
        }
    }
}

// MARK: - Methods

extension FeedViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.searchBar.alpha = 0.0
        }) { [weak self] (finished) in
            guard let strongSelf = self else {
                return
            }
            
            if let navigationController = strongSelf.navigationController {
                navigationController.navigationBar.topItem?.titleView = strongSelf.titleLabel
                navigationController.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(customView: strongSelf.searchButton), animated: false)
            }
        }
    }
}

