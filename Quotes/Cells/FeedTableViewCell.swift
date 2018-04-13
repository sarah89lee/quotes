//
//  FeedTableViewCell.swift
//  quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

struct User {
    var userId: String
    var fullName: String
}

class FeedTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var heardByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - UIView Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 20.0
    }
    
    // MARK: - Public Methods
    
    func setQuote(quote: String) {
        let rightAttachment = NSTextAttachment()
        rightAttachment.image = UIImage(named: "rightQuotations")

        let rightAttachmentString = NSAttributedString(attachment: rightAttachment)
        let quoteString = NSMutableAttributedString(string: quote)
        let mutableQuoteString = NSMutableAttributedString(attributedString: quoteString)
        
        mutableQuoteString.append(NSAttributedString(string: " "))
        mutableQuoteString.append(rightAttachmentString)
        
        quoteLabel.attributedText = mutableQuoteString
        
        let testData = [
            User(userId: "1", fullName: "Robert Smith"),
            User(userId: "2", fullName: "Bilbo Baggins"),
            User(userId: "3", fullName: "Luke Skywalker")
        ]
        
        setHeardByNames(names: testData)
    }
    
    func setHeardByNames(names: [User]) {
        let quoteString = NSMutableAttributedString(string: "Heard By: ")
        
        for i in 0..<names.count {
            let user: User = names[i]

            let attributedString = NSAttributedString(
                string: user.fullName,
                attributes: [
                    NSAttributedStringKey.foregroundColor : UIColor.black,
                    NSAttributedStringKey.link : user.userId,
                    NSAttributedStringKey.font : UIFont.extraBoldFont(size: 14.0),
                    NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                    NSAttributedStringKey.underlineColor : UIColor.black
                ]
            )

            quoteString.append(attributedString)
            
            // if there are more names, add a comma
            if i + 1 < names.count {
                quoteString.append(NSMutableAttributedString(string: ", "))
            }
        }
        
        heardByLabel.attributedText = quoteString
    }
}
