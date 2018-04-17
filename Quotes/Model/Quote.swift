//
//  Quote.swift
//  Quotes
//
//  Created by Sarah Lee on 4/14/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class Quote: NSObject, NSCoding {
    
    public var quote: String
    public var saidByPhoneNumber: String
    public var heardByPhoneNumbers: [String]
    public var date: Date
    
    init(quote: String, date: Date, saidBy: String, heardBy: [String]) {
        self.quote = quote
        self.date = date
        self.saidByPhoneNumber = saidBy
        self.heardByPhoneNumbers = heardBy
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(quote, forKey: "quote")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(saidByPhoneNumber, forKey: "saidByPhoneNumber")
        aCoder.encode(heardByPhoneNumbers, forKey: "heardByPhoneNumbers")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        quote = aDecoder.decodeObject(forKey: "quote") as! String
        date = aDecoder.decodeObject(forKey: "date") as! Date
        saidByPhoneNumber = aDecoder.decodeObject(forKey: "saidByPhoneNumber") as! String
        heardByPhoneNumbers = aDecoder.decodeObject(forKey: "heardByPhoneNumbers") as! [String]
    }
}
