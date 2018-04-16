//
//  Config.swift
//  Quotes
//
//  Created by Sarah Lee on 4/15/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

class Config: NSObject {
    
    private static var preferences: UserDefaults = UserDefaults.standard
    
    private static let LOGGED_IN_USER: String                             = "config.quotes.loggedInUser";
    private static let LOGGED_IN_USER_ID: String                          = "config.quotes.loggedInUserId";
    private static let LOGGED_IN_USER_PHONE_NUMBER: String                = "config.quotes.loggedInUserPhoneNumber";
    private static let LOGGED_IN_USER_IMAGE: String                       = "config.quotes.loggedInUserImage";
    
    public static func setLoggedInUser(user: QuotesUser?) {
        if let user = user {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
            setObject(key: LOGGED_IN_USER, value: encodedData)
        } else {
            setObject(key: LOGGED_IN_USER, value: nil)
        }
    }
    
    public static func getLoggedInUser() -> QuotesUser? {
        let data = UserDefaults.standard.object(forKey: LOGGED_IN_USER) as? NSData
        
        if let data = data, let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? QuotesUser {
            return user
        }
        
        return nil
    }
    
    public static func setLoggedInUserImage(image: UIImage?) {
        if let image = image {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: image)
            setObject(key: LOGGED_IN_USER_IMAGE, value: encodedData)
        } else {
            setObject(key: LOGGED_IN_USER_IMAGE, value: nil)
        }
    }
    
    public static func getLoggedInUserImage() -> UIImage? {
        let data = UserDefaults.standard.object(forKey: LOGGED_IN_USER_IMAGE) as? NSData
        
        if let data = data, let image = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UIImage {
            return image
        }
        
        return nil
    }
    
    public static func setLoggedInUserPhoneNumber(phoneNumber: String?) {
        setObject(key: LOGGED_IN_USER_PHONE_NUMBER, value: phoneNumber)
    }
    
    public static func getLoggedInUserPhoneNumber() -> String? {
        return Config.preferences.value(forKey: LOGGED_IN_USER_PHONE_NUMBER) as? String
    }
    
    public static func setLoggedInUserId(userId: String?) {
        setObject(key: LOGGED_IN_USER_ID, value: userId)
    }
    
    public static func getLoggedInUserId() -> String? {
        return Config.preferences.value(forKey: LOGGED_IN_USER_ID) as? String
    }
    
    public static func setObject(key: String, value: Any?) {
        if let value = value {
            Config.preferences.set(value, forKey: key)
        } else {
            Config.preferences.removeObject(forKey: key)
        }
        Config.preferences.synchronize()
    }
}
