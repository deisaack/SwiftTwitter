//
//  Notification.swift
//  Twitter
//
//  Created by De Isaac on 7/13/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    
    let tweetID: String?
    let timestamp: Date!
    var user: User
    let tweet: Tweet?
    let type: NotificationType!
    
    init(user: User, tweet: Tweet?, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        self.tweetID = dictionary["tweetID"] as? String ?? nil
        
        print("DEBUG: Dictionary is \(dictionary)")
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        } else {
            self.timestamp = Date()
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        } else {
            self.type = .follow
        }
    }
}
