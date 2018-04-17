//
//  ProfileFeedCollectionViewCell.swift
//  Quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class ProfileFeedCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    var quotesDatasource: [Quote] = [Quote]()
    
    fileprivate var quotesUsers: [QuotesUser] {
        get {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let users = appDelegate.generateUsersAndQuotesController?.users ?? [QuotesUser]()
            return users
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIView Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.layoutMargins = UIEdgeInsets.zero
    }
}

// MARK: -

extension ProfileFeedCollectionViewCell: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeedTableViewCell {
            let quote = quotesDatasource[indexPath.row]
            let saidByUser: [QuotesUser] = quotesUsers.filter{ $0.phoneNumber == quote.saidByPhoneNumber }
            let heardByUsers: [QuotesUser] = quotesUsers.filter{ quote.heardByPhoneNumbers.contains($0.phoneNumber) }
            if saidByUser.count > 0 {
                cell.setUserName(name: saidByUser[0].fullName)
                cell.setQuote(quote: quotesDatasource[indexPath.row].quote)
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
        let rect = quotesDatasource[indexPath.row].quote.boundingRect(
            with: CGSize(width: 120, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            context: nil
        )
        
        return defaultCellHeight + rect.height
    }
}

// MARK: -

extension ProfileFeedCollectionViewCell: UITableViewDataSource {

    // MARK: - UITableViewDataSource Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotesDatasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.setQuote(quote: "Everything happens for a reason. Testing long quote blah blah blah")
        return cell
    }
}
