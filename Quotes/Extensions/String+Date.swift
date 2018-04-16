//
//  String+Date.swift
//  Quotes
//
//  Created by Sarah Lee on 4/15/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import Foundation

extension String {
    
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self) ?? Date()
    }
}
