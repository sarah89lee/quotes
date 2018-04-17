//
//  LoginViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/15/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController {
    
     // MARK: - Properties

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBottomViewConstraint: NSLayoutConstraint!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.handleKeyboardWillShowNotification(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Action Methods
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        Config.setLoggedInUserPhoneNumber(phoneNumber: phoneNumberTextField.text)
        
        dismiss(animated: true, completion: nil)
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // request contacts permission and create mock data to store into Firebase
        appDelegate.generateUsersAndQuotesController?.requestContactsPermissionAndMockData()
    }
    
    // MARK: - NSNotificationCenter Observer Methods
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        let info = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let rawFrame: CGRect = value.cgRectValue
        let keyboardHeight = rawFrame.height
        
        // animate the bottom of the content view with the keyboard so it doesn't cover the login button
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.loginButtonBottomViewConstraint.constant = keyboardHeight
            strongSelf.view.layoutIfNeeded()
        }
    }
}
