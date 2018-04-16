//
//  UIAlertController+Show.swift
//  Quotes
//
//  Created by Sarah Lee on 4/15/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func showErrorWithMessage(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(self.okAction())
        
        UIViewController.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        for action in actions {
            alert.addAction(action)
        }
        
        UIViewController.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func okAction() -> UIAlertAction {
        return UIAlertAction(
            title: "OK",
            style: .default,
            handler:nil)
    }
}
