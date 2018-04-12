//
//  UIWindow+SafeAreaInsets.swift
//  Quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

extension UIWindow {
    
    class func safeAreaInsets() -> UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
    }
}
