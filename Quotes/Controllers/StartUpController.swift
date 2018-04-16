//
//  StartUpController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/15/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class StartUpController: NSObject {
    
    class func checkUserAuthentication(viewController: UIViewController) {
        // if we have a logged in user, or a logged in user's phone number, we have enough to populate mock data so
        // don't prompt the user to login
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if Config.getLoggedInUser() == nil && Config.getLoggedInUserPhoneNumber() == nil {
            let gateViewController: LoginViewController = UIStoryboard(
                name: "Main",
                bundle: nil
                ).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            viewController.present(gateViewController, animated: true, completion: nil)
        }  else {
            // request contacts permission and create mock data to store into Firebase
            appDelegate.generateUsersAndQuotesController?.requestContactsPermissionAndMockData()
        }
    }
}

extension UIViewController {
    
    class func topViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
