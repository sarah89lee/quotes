//
//  QuotesUser.swift
//  quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class QuotesUser: NSObject, NSCoding {

    //public var userId: String
    public var phoneNumber: String
    public var firstName: String
    public var lastName: String
    public var image: UIImage?
    public var fullName: String {
        get {
            return firstName + " " + lastName
        }
    }

    init(firstName: String, lastName: String, phoneNumber: String, image: UIImage?) {
        //self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.image = image
    }

    public func encode(with aCoder: NSCoder) {
        //aCoder.encode(userId, forKey: "userId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
    }

    public required init?(coder aDecoder: NSCoder) {
        //userId = aDecoder.decodeObject(forKey: "userId") as! String
        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
    }
}
