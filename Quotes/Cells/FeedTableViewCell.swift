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
    @IBOutlet weak var quoteHeightConstraint: NSLayoutConstraint!
    
    // MARK: - UIView Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 20.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
    
    // MARK: - Public Methods
    
    func setUserImage(image: UIImage) {
        avatarImageView.image = image
        avatarImageView.layer.cornerRadius = 20.0
        avatarImageView.layer.masksToBounds = true
    }
    
    func setUserName(name: String) {
        nameButton.setTitle(name, for: UIControlState.normal)
    }
    
    func setQuote(quote: String) {
        let rightAttachment = NSTextAttachment()
        rightAttachment.image = UIImage(named: "rightQuotations")

        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping

        let rightAttachmentString = NSAttributedString(attachment: rightAttachment)
        let quoteString = NSMutableAttributedString(string: quote)
        let mutableQuoteString = NSMutableAttributedString(attributedString: quoteString)
        
        mutableQuoteString.append(NSAttributedString(string: " "))
        mutableQuoteString.append(rightAttachmentString)
        
        mutableQuoteString.addAttributes([NSAttributedStringKey.paragraphStyle: mutableParagraphStyle], range: NSMakeRange(0, quote.count))
        
        quoteLabel.attributedText = mutableQuoteString
        
        let rect = mutableQuoteString.boundingRect(
            with: CGSize(width: 120, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            context: nil
        )

        quoteHeightConstraint.constant = rect.height
    }
    
    func setHeardByNames(names: [QuotesUser]) {
        let quoteString = NSMutableAttributedString(string: "Heard By: ")
        
        for i in 0..<names.count {
            let user: QuotesUser = names[i]

            let attributedString = NSAttributedString(
                string: user.fullName,
                attributes: [
                    NSAttributedStringKey.foregroundColor : UIColor.black,
                    NSAttributedStringKey.link : user.phoneNumber,
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
