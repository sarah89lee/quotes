//
//  ProfileViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

enum ProfileViewControllerSectionTypes: Int {
    case Header
    case Selection
    case Feed
}

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ProfileHeaderTableViewCell"
        )
        
        tableView.register(
            UINib(nibName: "ProfileQuotesSelectionTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ProfileQuotesSelectionTableViewCell"
        )
        
        tableView.register(
            UINib(nibName: "ProfileQuotesTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ProfileQuotesTableViewCell"
        )
        
        tableView.layoutMargins = UIEdgeInsets.zero
    }
}

// MARK: -

extension ProfileViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let headerHeight: CGFloat = 280.0
        let selectionHeight: CGFloat = 50.0
        if indexPath.row == ProfileViewControllerSectionTypes.Header.rawValue {
            return headerHeight
        } else if indexPath.row == ProfileViewControllerSectionTypes.Selection.rawValue {
            return selectionHeight
        } else if indexPath.row == ProfileViewControllerSectionTypes.Feed.rawValue {
            return view.bounds.height - headerHeight - selectionHeight
        }
        return 0
    }
}

// MARK: -

extension ProfileViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        if indexPath.row == ProfileViewControllerSectionTypes.Header.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTableViewCell", for: indexPath) as! ProfileHeaderTableViewCell
        } else if indexPath.row == ProfileViewControllerSectionTypes.Selection.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileQuotesSelectionTableViewCell", for: indexPath) as! ProfileQuotesSelectionTableViewCell
        } else if indexPath.row == ProfileViewControllerSectionTypes.Feed.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileQuotesTableViewCell", for: indexPath) as! ProfileQuotesTableViewCell
        }
        return cell
    }
}
