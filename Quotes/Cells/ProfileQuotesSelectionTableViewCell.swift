//
//  ProfileQuotesSelectionTableViewCell.swift
//  Quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class ProfileQuotesSelectionTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var saidByButton: UIButton!
    @IBOutlet weak var heardByButton: UIButton!
    
    // MARK: - UIView Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saidByButton.backgroundColor = UIColor.clear
        heardByButton.backgroundColor = UIColor.clear
        saidByButton.setTitleColor(UIColor.lightGrayColor(), for: UIControlState.normal)
        saidByButton.setTitleColor(UIColor.quotesPinkColor(), for: UIControlState.selected)
        heardByButton.setTitleColor(UIColor.lightGrayColor(), for: UIControlState.normal)
        heardByButton.setTitleColor(UIColor.quotesPinkColor(), for: UIControlState.selected)
        
        // said by tab is selected by default
        saidByButton.isSelected = true
    }
    
    // MARK: - Public Methods
    
    @IBAction func saidByButtonTouched(_ sender: Any) {
        saidByButton.isSelected = true
        heardByButton.isSelected = false
    }
 
    @IBAction func heardByButtonTouched(_ sender: Any) {
        saidByButton.isSelected = false
        heardByButton.isSelected = true
    }
}
