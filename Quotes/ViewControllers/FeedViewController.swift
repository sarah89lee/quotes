//
//  FeedViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit
import PKHUD

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var searchBar = UISearchBar(frame: CGRect.zero)

    fileprivate var searchView: SearchView!

    fileprivate let searchButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "SearchIcon"), for: UIControlState.normal)
        button.sizeToFit()
        return button
    }()
    
    fileprivate var quotesDatasource: [Quote] = [Quote]()
    fileprivate var quotesUsers: [QuotesUser] {
        get {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let users = appDelegate.generateUsersAndQuotesController?.users ?? [QuotesUser]()
            return users
        }
    }
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView = UINib(nibName: "SearchView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SearchView
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.isHidden = true
        view.addSubview(searchView)
        searchView.pinToAllSidesOfParent()
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.layoutMargins = UIEdgeInsets.zero
        
        searchButton.addTarget(
            self,
            action: #selector(FeedViewController.searchButtonTouched(_:)),
            for: UIControlEvents.touchUpInside
        )
        
        setNavigationBarTitleAndSearch()
        
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleQuotesGeneratedNotification(_:)),
            name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    fileprivate func setNavigationBarTitleAndSearch() {
        if let navigationController = navigationController,
            let navigationBar = navigationController.navigationBar as? QuotesNavigationBar {
            navigationBar.setNavigationBar(title: "QUOTES", tint: QuotesNavigationBarTint.Light)
            navigationBar.topItem?.setRightBarButton(UIBarButtonItem(customView: searchButton), animated: false)
        }
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
            self?.searchBar.placeholder = "Search who said it or who heard it"
            self?.searchBar.setShowsCancelButton(true, animated: true)
            self?.searchBar.becomeFirstResponder()
            self?.searchView.isHidden = false
            
            topItem.titleView = self?.searchBar
        }
    }
    
    // MARK: - NSNotificationCenter Observer Methods
    
    @objc func handleQuotesGeneratedNotification(_ notification: Notification) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let generateUsersAndQuotesController = appDelegate.generateUsersAndQuotesController {
            quotesDatasource = generateUsersAndQuotesController.getLoggedInUsersQuotes()
            tableView.reloadData()
        }
    }
}

// MARK: - Methods

extension FeedViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.searchBar.alpha = 0.0
            self?.searchView.isHidden = true
        }) { [weak self] (finished) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.setNavigationBarTitleAndSearch()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchView.searchQuoteUser(searchTerm: searchText)
    }
}

// MARK: -

extension FeedViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeedTableViewCell {
            let quote = quotesDatasource[indexPath.row]
            let saidByUser: [QuotesUser] = quotesUsers.filter{ $0.userId == quote.saidByUserId }
            let heardByUsers: [QuotesUser] = quotesUsers.filter{ quote.heardByUserIds.contains($0.userId) }
            if saidByUser.count > 0 {
                cell.setUserName(name: saidByUser[0].fullName)
                cell.setQuote(quote: quotesDatasource[indexPath.row].quote)
                cell.setHeardByNames(names: heardByUsers)
                cell.dateLabel.text = quote.date.toString(dateFormat: "dd-MMM-yyyy")
                
                if let image = saidByUser[0].image {
                    cell.setUserImage(image: image)
                }
                
                // we finally have data! let's hid the hud
                HUD.hide()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultCellHeight: CGFloat = 100.0
        let rect = quotesDatasource[indexPath.row].quote.boundingRect(
            with: CGSize(width: 120, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            context: nil
        )
        
        return defaultCellHeight + rect.height
    }
}

// MARK: -

extension FeedViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // sometimes the quotes return before the user, so let's make sure we have users first before
        // we display the cell, otherwise you will see the temporary cell labels and that is not pretty
        return quotesUsers.count > 0 ? quotesDatasource.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        return cell
    }
}
