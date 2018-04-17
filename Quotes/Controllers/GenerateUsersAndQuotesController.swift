//
//  GenerateUsersAndQuotesController.swift
//  Quotes
//
//  Created by Sarah Lee on 4/14/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import SwiftyContacts
import Contacts
import PKHUD

/// This class creates a user object for all contacts on a user's phone
class GenerateUsersAndQuotesController: NSObject {
    
    // MARK: - Properties
    
    static let QUOTES_GENERATED_NOTIFICATION        = "config.quotes.quotesGenerated"
    static let QUOTES_PLIST                         = "quotes.plist"
    static let USERS_PLIST                          = "users.plist"
    
    var quotesString: [String] = [String]()
    var quotes: [Quote] = [Quote]()
    var users: [QuotesUser] = [QuotesUser]()
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    private var quotesDictionary: [String: String] = [String: String]()
    private let fileManager: FileManager = FileManager.default
    private let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    private var quotesPlistPath: String {
        get {
            return documents.appendingPathComponent(GenerateUsersAndQuotesController.QUOTES_PLIST)
        }
    }
    private var usersPlistPath: String {
        get {
            return documents.appendingPathComponent(GenerateUsersAndQuotesController.USERS_PLIST)
        }
    }
    private var avatarImagePath: NSString {
        get {
            let path = documents.appendingPathComponent("avatarImages") as NSString
            if !fileManager.fileExists(atPath: path as String, isDirectory: nil) {
                do {
                    try fileManager.createDirectory(atPath: path as String, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            return path
        }
    }
    private var usersPlistPathExists: Bool {
        get {
            return fileManager.fileExists(atPath: usersPlistPath, isDirectory: nil)
        }
    }
    private var quotesPlistPathExists: Bool {
        get {
            return fileManager.fileExists(atPath: quotesPlistPath, isDirectory: nil)
        }
    }

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
    
    func removeData() {
        do {
            try fileManager.removeItem(atPath: usersPlistPath)
            try fileManager.removeItem(atPath: quotesPlistPath)
            try fileManager.removeItem(atPath: avatarImagePath as String)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func createQuote(quote: String, saidByPhoneNumber: String, heardByPhoneNumbers: [String], date: String) {
        if let quotesArray = NSArray(contentsOfFile: quotesPlistPath) {
            let mutableQuotesArray = NSMutableArray(array: quotesArray)
            
            let quoteDict = [
                "quote" : quote,
                "date" : date,
                "saidBy" : saidByPhoneNumber,
                "heardBy" : heardByPhoneNumbers
                ] as NSMutableDictionary
            
            mutableQuotesArray.add(quoteDict)
            mutableQuotesArray.write(toFile: quotesPlistPath, atomically: true)
            
            // retrieve the quotes again so we can refresh the feed
            getQuotes()
        }
    }
    
    func getLoggedInUsersQuotes() -> [Quote] {
        let combinedArray = getLoggedInUserSaidByQuotes() + getLoggedInUserHeardByQuotes()
        return combinedArray.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    func getLoggedInUsersQuotesAllUsers() -> [QuotesUser] {
        let combinedArray = getLoggedInUserSaidByQuotes() + getLoggedInUserHeardByQuotes()
        let filteredArray = users.filter { quoteUser in
            combinedArray.contains(where: { $0.saidByPhoneNumber == quoteUser.phoneNumber || $0.heardByPhoneNumbers.contains(quoteUser.phoneNumber)}
        )}
        
        return filteredArray
    }
    
    func getLoggedInUserSaidByQuotes() -> [Quote] {
        guard let phoneNumber = Config.getLoggedInUserPhoneNumber() else {
            return [Quote]()
        }
        
        let filteredArray = quotes.filter{ $0.saidByPhoneNumber == phoneNumber }
        return filteredArray.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    func getLoggedInUserHeardByQuotes() -> [Quote] {
        guard let phoneNumber = Config.getLoggedInUserPhoneNumber() else {
            return [Quote]()
        }
        
        let filteredArray = quotes.filter{ $0.heardByPhoneNumbers.contains(phoneNumber) }
        return filteredArray.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    func getQuotes() {
        quotes.removeAll()
        
        if !quotesPlistPathExists {
            return
        }
        
        if let quotesArray = NSArray(contentsOfFile: quotesPlistPath) {
            if quotesArray.count == 0 {
                return
            }
            
            for dict in quotesArray {
                if let dictionary = dict as? NSDictionary,
                    let quote = dictionary["quote"],
                    let date = dictionary["date"],
                    let saidBy = dictionary["saidBy"],
                    let heardBy = dictionary["heardBy"] as? NSArray {
                    let quote = Quote(
                        quote: quote as! String,
                        date: (date as! String).toDate(dateFormat: "dd-MMM-yyyy") ,
                        saidBy: saidBy as! String,
                        heardBy: heardBy as! [String]
                        
                    )
                    quotes.append(quote)
                }
            }
        }

        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION)))
    }
    
    func getUsers() {
        users.removeAll()
        
        if !usersPlistPathExists {
            return
        }
        
        if let usersArray = NSArray(contentsOfFile: usersPlistPath) {
            if usersArray.count == 0 {
                return
            }
            
            for dict in usersArray {
                if let dictionary = dict as? NSDictionary,
                    let firstName = dictionary["firstName"],
                    let lastName = dictionary["lastName"],
                    let phoneNumber = dictionary["phoneNumber"],
                    let avatarImageName = dictionary["avatarImageName"] {
                    var image: UIImage?
                    if !(avatarImageName as! String).isEmpty {
                        let avatarPath = (avatarImagePath as NSString).appendingPathComponent("/\(avatarImageName as! String)")
                        if fileManager.fileExists(atPath: avatarPath) {
                            image = UIImage(contentsOfFile: avatarPath)
                        }
                    }
                    let user = QuotesUser(
                        firstName: firstName as! String,
                        lastName: lastName as! String,
                        phoneNumber: phoneNumber as! String,
                        image: image
                    )
                    users.append(user)
                }
            }
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION)))
    }
    
    // MARK: - Private Methods
    
    fileprivate func getContacts() {
        fetchContacts(completionHandler: { [weak self] (result) in
            switch result{
            case .Success(response: let contacts):
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.usersPlistPathExists && strongSelf.quotesPlistPathExists {
                    strongSelf.getQuotes()
                    strongSelf.getUsers()
                    return
                }
                
                // only get contacts with a first and last name
                let filteredContacts = contacts.filter { !$0.givenName.isEmpty && !$0.familyName.isEmpty }
                strongSelf.createUsers(contacts: filteredContacts, completion: { [weak self] () in
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
        let usersDictionaryArray: NSMutableArray = NSMutableArray()
        
        for contact in contacts {
            if contact.phoneNumbers.count > 0,
                let phoneNumber = contact.phoneNumbers[0].value.value(forKey: "stringValue") as? String {
                let phoneOnlyNumbers = String(phoneNumber.filter {"01234567890.".contains($0)})
                
                // store the image in the avatarImages folder in the documents directory
                var imagePath: String = ""
                var avatarImage: UIImage = UIImage()
                if contact.isKeyAvailable(CNContactImageDataKey) {
                    if let contactImageData = contact.imageData, let image = UIImage(data: contactImageData) {
                        avatarImage = image
                        
                        imagePath = avatarImagePath.appendingPathComponent("\(contact.givenName)\(contact.familyName).jpg")
                      
                        let imageData = UIImageJPEGRepresentation(image, 0.5)
                        fileManager.createFile(atPath: imagePath as String, contents: imageData, attributes: nil)
                    }
                }
                
                let value = [
                    "firstName" : contact.givenName,
                    "lastName" : contact.familyName,
                    "phoneNumber" : phoneOnlyNumbers,
                    "avatarImageName" : ("\(contact.givenName)\(contact.familyName).jpg")
                ]
                
                usersDictionaryArray.add(value)
                
                let user = QuotesUser(
                    firstName: contact.givenName,
                    lastName: contact.familyName,
                    phoneNumber: phoneOnlyNumbers,
                    image: avatarImage
                )
                
                users.append(user)
                
                if let loggedInUserPhoneNumber = Config.getLoggedInUserPhoneNumber(),
                    phoneOnlyNumbers.contains(loggedInUserPhoneNumber) {
                    Config.setLoggedInUser(user: user)
                    Config.setLoggedInUserImage(image: avatarImage)
                }
            }
        }
        
        usersDictionaryArray.write(toFile: usersPlistPath, atomically: true)
        
        completion()
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

        let quotesDictionaryArray: NSMutableArray = NSMutableArray()
        
        for _ in 0..<quotesString.count {
            let quoteRandomInt = Int(arc4random_uniform(UInt32(quotesString.count)))
            let userRandomInt = Int(arc4random_uniform(UInt32(users.count)))
            let quoteString = quotesString[quoteRandomInt]

            let randomUser = users[userRandomInt]
            let saidByUser = randomUser

            // let's assign heardBy users and for testing purposes, just restrict it to a max of 3 users
            let heardByMaxInt = Int(arc4random_uniform(UInt32(3))) + 1
            var heardByUsers: [String] = [String]()
            
            for _ in 0..<heardByMaxInt {
                let heardByRandomInt = Int(arc4random_uniform(UInt32(users.count)))
                let randomHeardByUser = users[heardByRandomInt]
                heardByUsers.append(randomHeardByUser.phoneNumber)
            }

            let randomDate: Date = generateRandomDate(daysBack: 30) ?? Date()
            
            let value = [
                "quote" : quoteString,
                "date" : randomDate.toString(dateFormat: "dd-MMM-yyyy"),
                "saidBy" : saidByUser.phoneNumber,
                "heardBy" : heardByUsers
                ] as [String : Any]
            
            quotesDictionaryArray.add(value)
            
            let quote = Quote(
                quote: quoteString,
                date: randomDate,
                saidBy: saidByUser.phoneNumber,
                heardBy: heardByUsers
            
            )
            quotes.append(quote)
        }
        
        quotesDictionaryArray.write(toFile: quotesPlistPath, atomically: true)
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: GenerateUsersAndQuotesController.QUOTES_GENERATED_NOTIFICATION)))
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
