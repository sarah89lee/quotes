//
//  QuotesNavigationBar.swift
//  Quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

enum QuotesNavigationBarTint {
    case Light
    case Dark
}

class QuotesNavigationBar: UINavigationBar {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "QUOTES"
        label.font = UIFont.extraBoldFont(size: 20.0)
        label.textColor = UIColor.quotesPinkColor()
        return label
    }()

    // MARK: - Public Methods
    
    func setNavigationBar(title: String, tint: QuotesNavigationBarTint) {
        topItem?.titleView = titleLabel
        titleLabel.text = title
        
        if tint == QuotesNavigationBarTint.Dark {
            titleLabel.textColor = UIColor.white
            barTintColor = UIColor.navigationBarPinkColor()
            setValue(true, forKey: "hidesShadow")
        } else {
            titleLabel.textColor = UIColor.quotesPinkColor()
            barTintColor = UIColor.white
            setValue(false, forKey: "hidesShadow")
        }

        isTranslucent = false
    }
}
