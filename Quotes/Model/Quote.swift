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
    public var saidByUserId: String
    public var heardByUserIds: [String]
    public var date: Date
    
    init(quote: String, date: Date, saidBy: String, heardBy: [String]) {
        self.quote = quote
        self.date = date
        self.saidByUserId = saidBy
        self.heardByUserIds = heardBy
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(quote, forKey: "quote")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(saidByUserId, forKey: "saidByUserId")
        aCoder.encode(heardByUserIds, forKey: "heardByUserIds")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        quote = aDecoder.decodeObject(forKey: "quote") as! String
        date = aDecoder.decodeObject(forKey: "date") as! Date
        saidByUserId = aDecoder.decodeObject(forKey: "saidByUserId") as! String
        heardByUserIds = aDecoder.decodeObject(forKey: "heardByUserIds") as! [String]
    }
}
