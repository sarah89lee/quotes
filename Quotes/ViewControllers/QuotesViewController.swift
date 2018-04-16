//
//  QuotesViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var quoteItViewBottomConstraint: NSLayoutConstraint!
    
    static let maxCharacterCount: Int = 115
    
    fileprivate var counter: Int = 115
    
    fileprivate let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "QUOTES"
        label.font = UIFont.extraBoldFont(size: 20.0)
        label.textColor = UIColor.white
        return label
    }()
    
    fileprivate let cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitle("Cancel", for: UIControlState.normal)
        button.titleLabel?.font = UIFont.extraBoldFont(size: 14.0)
        return button
    }()

    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        cancelButton.addTarget(
            self,
            action: #selector(QuotesViewController.cancelButtonTouched(_:)),
            for: UIControlEvents.touchUpInside
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(QuotesViewController.handleKeyboardWillShowNotification(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(QuotesViewController.handleKeyboardWillHideNotification(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController,
            let navigationBar = navigationController.navigationBar as? QuotesNavigationBar {
            navigationBar.setNavigationBar(title: "QUOTES", tint: QuotesNavigationBarTint.Dark)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationController = navigationController,
            let navigationBar = navigationController.navigationBar as? QuotesNavigationBar {
            navigationBar.topItem?.setLeftBarButton(UIBarButtonItem(customView: cancelButton), animated: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quoteReviewViewController = segue.destination as? QuoteReviewViewController {
            quoteReviewViewController.quote = textView.text
        }
    }
    
    // MARK: - Action Methods
    
    @objc func cancelButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - NSNotificationCenter Observer Methods
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        let info = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let rawFrame: CGRect = value.cgRectValue
        let keyboardHeight = rawFrame.height
        
        // animate the bottom of the content view with the keyboard so it doesn't cover the login button
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.quoteItViewBottomConstraint.constant = keyboardHeight - UIWindow.safeAreaInsets().bottom
        }
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        let info = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let rawFrame: CGRect = value.cgRectValue
        let keyboardHeight = rawFrame.height
        
        // animate the bottom of the content view with the keyboard so it doesn't cover the login button
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.quoteItViewBottomConstraint.constant = UIWindow.safeAreaInsets().bottom
        }
    }
}

// MARK: -

extension QuotesViewController: UITextViewDelegate {
    
    // MARK: - UITextViewDelegate Methods
    
    func textViewDidChange(_ textView: UITextView) {
        counter = QuotesViewController.maxCharacterCount - textView.text.count
        counterLabel.text = "\(counter)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if counter == 0 && text.isEmpty {
            return true
        }
        return counter > 0
    }
}

