//
//  GenerateUsersAndQuotesController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/14/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import SwiftyContacts
import Contacts
import Firebase
import FirebaseDatabase
import PKHUD

/// This class creates a user object for all contacts on a user's phone
class GenerateUsersAndQuotesController: NSObject {
    
    // MARK: - Properties
    
    static let QUOTES_GENERATED_NOTIFICATION        = "config.quotes.quotesGenerated"
    
    var quotesString: [String] = [String]()
    var quotes: [Quote] = [Quote]()
    var users: [QuotesUser] = [QuotesUser]()
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    private var quotesDictionary: [String: String] = [String: String]()
    private var usersDictionary: [String: String] = [String: String]()
    private let databaseReference: DatabaseReference = Database.database().reference()
    
    // MARK: - Public Methods
    
    func requestContactsPermissionAndMockData() {
        HUD.show(HUDContentType.progress)
   
        requestAccess { [weak self] (response) in
            if response {
                self?.getContacts()
                print("Contacts Acess Granted")
            } else {
                print("Contacts Acess Denied")
            }
        }
    }
    
    func createQuote(quote: String, saidById: String, heardByIds: [String], date: String) {
        HUD.show(.progress)
        
        // if we have quotes already, let's clear the array since we're fetching them again
        quotes.removeAll()
        
        databaseReference.child("quotes").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            let value = [
                "quote" : quote,
                "date" : date,
                "saidBy" : saidById,
                "heardBy" : heardByIds
                ] as [String : Any]
            
            let autoId = strongSelf.databaseReference.childByAutoId()
            strongSelf.databaseReference.child("quotes").child(autoId.key).setValue(value)
            
            // let's store the id so we can easily retrive the quote object to attach the users to later
            strongSelf.quotesDictionary[quote] = autoId.key

            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION)))
        })
    }
    
    func getLoggedInUsersQuotes() -> [Quote] {
        let combinedArray = getLoggedInUserSaidByQuotes() + getLoggedInUserHeardByQuotes()
        return combinedArray.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    func getLoggedInUsersQuotesAllUsers() -> [QuotesUser] {
        let combinedArray = getLoggedInUserSaidByQuotes() + getLoggedInUserHeardByQuotes()
        let filteredArray = users.filter { quoteUser in
            combinedArray.contains(where: { $0.saidByUserId == quoteUser.userId || $0.heardByUserIds.contains(quoteUser.userId)}
        )}
        
        return filteredArray
    }
    
    func getLoggedInUserSaidByQuotes() -> [Quote] {
        guard let userId = Config.getLoggedInUserId() else {
            return [Quote]()
        }
        
        let filteredArray = quotes.filter{ $0.saidByUserId == userId }
        return filteredArray.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    func getLoggedInUserHeardByQuotes() -> [Quote] {
        guard let userId = Config.getLoggedInUserId() else {
            return [Quote]()
        }
        
        let filteredArray = quotes.filter{ $0.heardByUserIds.contains(userId) }
        return filteredArray.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    func getQuotes() {
        // if we have quotes already, let's clear the array since we're fetching them again
        quotes.removeAll()

        databaseReference.child("quotes").observe(.value, with: { [weak self] snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if let dict = rest.value as? NSDictionary,
                    let quoteString = dict.object(forKey: "quote") as? String,
                    let date = dict.object(forKey: "date") as? String,
                    let saidBy = dict.object(forKey: "saidBy") as? String,
                    let heardBy = dict.object(forKey: "heardBy") as? [String] {
                    let quote = Quote(quote: quoteString, date: date.toDate(dateFormat: "dd-MMM-yyyy"), saidBy: saidBy, heardBy: heardBy)
                    self?.quotes.append(quote)
                }
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION)))
        })
    }
    
    func getUsers() {
        // if we have users already, let's clear the array since we're fetching them again
        if users.count > 0 {
            users.removeAll()
        }
        
        databaseReference.child("users").observe(.value, with: { [weak self] snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if let dict = rest.value as? NSDictionary,
                    let firstName = dict.object(forKey: "firstName") as? String,
                    let lastName = dict.object(forKey: "lastName") as? String,
                    let phoneNumber = dict.object(forKey: "phoneNumber") as? String,
                    let imageData = dict.object(forKey: "imageData") as? String {
                    let stringToData = NSData(base64Encoded: imageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                    let user = QuotesUser(userId: rest.key, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, image: stringToData == nil ? nil :UIImage(data: stringToData! as Data))
                    
                    if let loggedInUserPhoneNumber = Config.getLoggedInUserPhoneNumber(),
                        phoneNumber.contains(loggedInUserPhoneNumber) {
                        Config.setLoggedInUser(user: user)
                        
                        let image = stringToData == nil ? nil : UIImage(data: stringToData! as Data)
                        Config.setLoggedInUserImage(image: image)
                    }

                    self?.users.append(user)
                }
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION)))
        })
    }
    
    // MARK: - Private Methods
    
    fileprivate func getContacts() {
        fetchContacts(completionHandler: { [weak self] (result) in
            switch result{
            case .Success(response: let contacts):
                // only get contacts with a first and last name
                let filteredContacts = contacts.filter { !$0.givenName.isEmpty && !$0.familyName.isEmpty }

                self?.createUsers(contacts: filteredContacts, completion: { [weak self] () in
                    self?.fetchQuotes()
                })
                break
            case .Error(error: let error):
                print(error)
                break
            }
        })
    }
    
    fileprivate func createUsers(contacts: [CNContact], completion: @escaping () -> ()) {
        databaseReference.child("users").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            if snapshot.childrenCount > 0 && Config.getLoggedInUser() != nil {
                strongSelf.getQuotes()
                strongSelf.getUsers()
                completion()
                return
            }
            for contact in contacts {
                if contact.phoneNumbers.count > 0,
                    let phoneNumber = contact.phoneNumbers[0].value.value(forKey: "stringValue") as? String {
                    let phoneOnlyNumbers = String(phoneNumber.filter {"01234567890.".contains($0)})
                
                    var imageData: Data?
                    var imageDataString: String = ""
                    if contact.isKeyAvailable(CNContactImageDataKey) {
                        if let contactImageData = contact.imageData {
                            imageData = UIImagePNGRepresentation(UIImage(data: contactImageData)!)
                            imageDataString = imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                        }
                    }
                 
                    let value = [
                        "firstName" : contact.givenName,
                        "lastName" : contact.familyName,
                        "phoneNumber" : phoneOnlyNumbers,
                        "imageData" : imageDataString
                    ]
                    
                    let autoId = strongSelf.databaseReference.childByAutoId()
                    strongSelf.databaseReference.child("users").child(autoId.key).setValue(value)
                    strongSelf.usersDictionary[phoneOnlyNumbers] = autoId.key

                    let user = QuotesUser(userId: autoId.key, firstName: contact.givenName, lastName: contact.familyName, phoneNumber: phoneOnlyNumbers, image: imageData == nil ? nil : UIImage(data: imageData!))
                    strongSelf.users.append(user)
                    
                    if let loggedInUserPhoneNumber = Config.getLoggedInUserPhoneNumber(),
                        phoneOnlyNumbers.contains(loggedInUserPhoneNumber) {
                        Config.setLoggedInUser(user: user)
                        Config.setLoggedInUserId(userId: autoId.key)
                        let image = imageData == nil ? nil : UIImage(data: imageData! as Data)
                        Config.setLoggedInUserImage(image: image)
                    }
                }
            }
            
            completion()
        })
    }
    
    fileprivate func fetchQuotes() {
        // get a list of quotes
        QuotesHTTP.makeApiRequest("https://raw.githubusercontent.com/4skinSkywalker/Database-Quotes-JSON/master/quotes.json") { [weak self] (dataResponse) in
            if let json = dataResponse.value, let array = json.arrayObject {
                for dictionary in array {
                    if let dict = dictionary as? [String: String], let quote = dict["quoteText"] {
                        self?.quotesString.append(quote)
                    }
                }
            }
            
            self?.createQuotes()
        }
    }
    
    fileprivate func createQuotes() {
        guard users.count > 0 else {
            return
        }
        
        // let's just create 200 quotes
        for _ in 0..<200 {
            let quoteRandomInt = Int(arc4random_uniform(UInt32(quotesString.count)))
            let userRandomInt = Int(arc4random_uniform(UInt32(users.count)))
            let quoteString = quotesString[quoteRandomInt]

            let randomUser = users[userRandomInt]
            let saidByUser = randomUser

            // let's assign heardBy users and for testing purposes, just restrict it to a max of 3 users
            let heardByMaxInt = Int(arc4random_uniform(UInt32(3))) + 1
            var heardByUsers: [QuotesUser] = [QuotesUser]()
            
            for _ in 0..<heardByMaxInt {
                let heardByRandomInt = Int(arc4random_uniform(UInt32(users.count)))
                let randomHeardByUser = users[heardByRandomInt]
                heardByUsers.append(randomHeardByUser)
            }

            let heardByPhoneNumbers = heardByUsers.map{ usersDictionary[$0.phoneNumber] }
            createQuotesDatabase(quoteString: quoteString, saidByUser: saidByUser, heardByUsers: heardByPhoneNumbers)
        }
    }
    
    fileprivate func createQuotesDatabase(quoteString: String, saidByUser: QuotesUser, heardByUsers: [String?]) {
        databaseReference.child("quotes").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            if snapshot.childrenCount > 0 && Config.getLoggedInUser() != nil {
                return
            }
            
            let randomDate: Date = strongSelf.generateRandomDate(daysBack: 30) ?? Date()
            
            let value = [
                "quote" : quoteString,
                "date" : randomDate.toString(dateFormat: "dd-MMM-yyyy"),
                "saidBy" : strongSelf.usersDictionary[saidByUser.phoneNumber] as! String,
                "heardBy" : heardByUsers
                ] as [String : Any]
            
            let autoId = strongSelf.databaseReference.childByAutoId()
            strongSelf.databaseReference.child("quotes").child(autoId.key).setValue(value)
            
            // let's store the id so we can easily retrive the quote object to attach the users to later
            strongSelf.quotesDictionary[quoteString] = autoId.key
            
            if let userId = strongSelf.usersDictionary[saidByUser.phoneNumber] {
                strongSelf.attachUserIdToQuote(userId: userId, date: randomDate, quote: quoteString, heardBy: heardByUsers)
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION)))
        })
    }

    fileprivate func attachUserIdToQuote(userId: String, date: Date, quote: String, heardBy: [String?]) {
        if let dictQuote = quotesDictionary[quote] {
            let quoteRef = databaseReference.child("quotes").child(dictQuote)
            quoteRef.updateChildValues(["saidBy" : userId, "heardBy" : heardBy])
            
            if let heardBy = heardBy as? [String] {
                let quote = Quote(quote: quote, date: date, saidBy: userId, heardBy: heardBy)
                quotes.append(quote)
            }
        }
    }
    
    fileprivate func generateRandomDate(daysBack: Int) -> Date? {
        // taken from https://gist.github.com/edmund-h/2638e87bdcc26e3ce9fffc0aede4bdad
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
}
