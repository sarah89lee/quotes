//
//  QuoteReviewViewController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit
import SwiftMultiSelect

enum QuoteReviewViewControllerTextField: Int {
    case SaidBy
    case HeardBy
}

class QuoteReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var saidTextField: UITextField!
    @IBOutlet weak var heardTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var successQuoteLabel: UILabel!
    
    fileprivate var currentTextFieldType: QuoteReviewViewControllerTextField = QuoteReviewViewControllerTextField.SaidBy
    fileprivate let reviewNavigationBar: QuotesNavigationBar = QuotesNavigationBar()
    
    var quote: String = ""
    
    fileprivate let backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(UIColor.quotesPinkColor(), for: UIControlState.normal)
        button.setTitle("Back", for: UIControlState.normal)
        button.titleLabel?.font = UIFont.extraBoldFont(size: 14.0)
        return button
    }()
    
    fileprivate let doneButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(UIColor.lightGrayColor(), for: UIControlState.normal)
        button.setTitle("Done", for: UIControlState.normal)
        button.titleLabel?.font = UIFont.extraBoldFont(size: 14.0)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "REVIEW"
        label.font = UIFont.extraBoldFont(size: 20.0)
        label.textColor = UIColor.quotesPinkColor()
        return label
    }()
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.titleView = titleLabel
        
        backButton.addTarget(
            self,
            action: #selector(QuoteReviewViewController.backButtonTouched(_:)),
            for: UIControlEvents.touchUpInside
        )
        
        doneButton.addTarget(
            self,
            action: #selector(QuoteReviewViewController.doneButtonTouched(_:)),
            for: UIControlEvents.touchUpInside
        )
        
        setSuccessQuotes()
        
        SwiftMultiSelect.dataSourceType = .phone
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController,
            let navigationBar = navigationController.navigationBar as? QuotesNavigationBar {
            navigationBar.setNavigationBar(title: "REVIEW", tint: QuotesNavigationBarTint.Light)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navigationController = navigationController,
            let navigationBar = navigationController.navigationBar as? QuotesNavigationBar {
            navigationBar.topItem?.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: false)
            navigationBar.topItem?.setRightBarButton(UIBarButtonItem(customView: doneButton), animated: false)
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func checkIfAllFieldsAreFilled() {
        if let saidByText = saidTextField.text, !saidByText.isEmpty,
            let heardByText = heardTextField.text, !heardByText.isEmpty,
            let monthText = monthTextField.text, !monthText.isEmpty,
            let dayText = dayTextField.text, !dayText.isEmpty,
            let yearText = yearTextField.text, !yearText.isEmpty {
            doneButton.setTitleColor(UIColor.quotesPinkColor(), for: UIControlState.normal)
        } else {
            doneButton.setTitleColor(UIColor.lightGrayColor(), for: UIControlState.normal)
        }
    }
    
    fileprivate func setSuccessQuotes() {
        let rightAttachment = NSTextAttachment()
        rightAttachment.image = UIImage(named: "rightQuotations")
        
        let rightAttachmentString = NSAttributedString(attachment: rightAttachment)
        let quoteString = NSMutableAttributedString(string: quote)
        let mutableQuoteString = NSMutableAttributedString(attributedString: quoteString)
        
        mutableQuoteString.append(NSAttributedString(string: " "))
        mutableQuoteString.append(rightAttachmentString)

        successQuoteLabel.attributedText = mutableQuoteString
    }
    // MARK: - Action Methods
    
    @objc func doneButtonTouched(_ sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if let generateUsersAndQuotesController = appDelegate.generateUsersAndQuotesController {
            let saidByUser = generateUsersAndQuotesController.users.filter { saidTextField.text!.contains($0.firstName) && saidTextField.text!.contains($0.lastName) }
            
            let heardByUsers = generateUsersAndQuotesController.users.filter { heardTextField.text!.contains($0.firstName) && heardTextField.text!.contains($0.lastName) }
            
            if saidByUser.count > 0 && heardByUsers.count > 0 {
                let heardByUsersIds = heardByUsers.map { $0.userId }
                let saidByUserId = saidByUser[0].userId
                
                let dateString: String = monthTextField.text! + "-" + dayTextField.text! + "-" + yearTextField.text!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                var date = Date()
                date = dateFormatter.date(from: dateString)!
                
                // convert to the date format we have on the server
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                let formattedDateString = dateFormatter.string(from: date)

                generateUsersAndQuotesController.createQuote(
                    quote: quote,
                    saidById: saidByUserId,
                    heardByIds: heardByUsersIds,
                    date: formattedDateString
                )
                
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func backButtonTouched(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saidByTextFieldDidBeginEditing(_ sender: Any) {
        currentTextFieldType = QuoteReviewViewControllerTextField.SaidBy
        SwiftMultiSelect.delegate = self
        SwiftMultiSelect.Show(to: self)
    }
    
    @IBAction func heardByTextFieldDidBeginEditing(_ sender: Any) {
        currentTextFieldType = QuoteReviewViewControllerTextField.HeardBy
        SwiftMultiSelect.delegate = self
        SwiftMultiSelect.Show(to: self)
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        checkIfAllFieldsAreFilled()
    }
}

// MARK: -

extension QuoteReviewViewController : SwiftMultiSelectDelegate {
    
    // MARK: - SwiftMultiSelectDelegate Methods
    
    func userDidSearch(searchString: String) {
        // NO-OP
    }
    
    func swiftMultiSelect(didUnselectItem item: SwiftMultiSelectItem) {
        // NO-OP
    }
    
    func swiftMultiSelect(didSelectItem item: SwiftMultiSelectItem) {
        if currentTextFieldType == QuoteReviewViewControllerTextField.SaidBy {
            saidTextField.text = item.title
            presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didCloseSwiftMultiSelect() {
        // NO-OP
    }
    
    func swiftMultiSelect(didSelectItems items: [SwiftMultiSelectItem]) {
        if currentTextFieldType == QuoteReviewViewControllerTextField.HeardBy {
            var selectedNames = ""
            for i in 0..<items.count {
                
                selectedNames += items[i].title
                // if there are more names, add a comma
                if i + 1 < items.count {
                    selectedNames += ", "
                }
            }
            
            heardTextField.text = selectedNames
        }
    }
}
