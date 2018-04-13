//
//  ProfileHeaderTableViewCell.swift
//  Quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - UIView Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoutButton.layer.borderColor = UIColor.quotesPinkColor().cgColor
        logoutButton.layer.borderWidth = 1.0
        logoutButton.layer.cornerRadius = 20.0
        
        avatarImageView.layer.cornerRadius = 50.0
    }

}
