//
//  SearchView.swift
//  Quotes
//
//  Created by Sarah Lee on 4/15/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    fileprivate var searchDatasource: [Quote] = [Quote]()
    fileprivate var quotesUsers: [QuotesUser] {
        get {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let users = appDelegate.generateUsersAndQuotesController?.users ?? [QuotesUser]()
            return users
        }
    }
    
    // MARK: - UIView Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.layoutMargins = UIEdgeInsets.zero
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.handleKeyboardWillShowNotification(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    func searchQuoteUser(searchTerm: String) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let allLoggedInUserQuotes = appDelegate.generateUsersAndQuotesController?.getLoggedInUserSaidByQuotes() ?? [Quote]()
        let allLoggedInUsers = appDelegate.generateUsersAndQuotesController?.getLoggedInUsersQuotesAllUsers() ?? [QuotesUser]()
    
        let filteredUsersArray = allLoggedInUsers.filter{ $0.fullName.contains(searchTerm) }
        
        let filteredQuotesArray = allLoggedInUserQuotes.filter { quote in
            filteredUsersArray.contains(where: { $0.userId == quote.saidByUserId || quote.heardByUserIds.contains($0.userId) }
            )}
        
        searchDatasource = filteredQuotesArray
        
        tableView.reloadData()
    }
    
    // MARK: - NSNotificationCenter Observer Methods
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        let info = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let rawFrame: CGRect = value.cgRectValue
        let keyboardHeight = rawFrame.height
        
        // animate the bottom of the content view with the keyboard so it doesn't cover the login button
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableViewBottomConstraint.constant = keyboardHeight - UIWindow.safeAreaInsets().bottom - UIWindow.safeAreaInsets().top
            strongSelf.layoutIfNeeded()
        }
    }
}

// MARK: -

extension SearchView: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeedTableViewCell {
            let quote = searchDatasource[indexPath.row]
            let saidByUser: [QuotesUser] = quotesUsers.filter{ $0.userId == quote.saidByUserId }
            let heardByUsers: [QuotesUser] = quotesUsers.filter{ quote.heardByUserIds.contains($0.userId) }
            if saidByUser.count > 0 {
                cell.setUserName(name: saidByUser[0].fullName)
                cell.setQuote(quote: searchDatasource[indexPath.row].quote)
                cell.setHeardByNames(names: heardByUsers)
                cell.dateLabel.text = quote.date.toString(dateFormat: "dd-MMM-yyyy")

                if let image = saidByUser[0].image {
                    cell.setUserImage(image: image)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultCellHeight: CGFloat = 100.0
        let rect = searchDatasource[indexPath.row].quote.boundingRect(
            with: CGSize(width: 120, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            context: nil
        )
        
        return defaultCellHeight + rect.height
    }
}

// MARK: -

extension SearchView: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        return cell
    }
}
