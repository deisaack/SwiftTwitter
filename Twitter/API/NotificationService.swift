//
//  NotificationService.swift
//  Twitter
//
//  Created by De Isaac on 7/13/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import Foundation

struct NotificationService {
    static let shared = NotificationService()
    
    
    func uploadNotification(type: NotificationType, user: User) {
        let values: [String: Any] = [
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "uid": USER_ID,
            "type": type.rawValue
        ]
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    func uploadNotification(type: NotificationType, tweet: Tweet) {
        var values: [String: Any] = [
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "uid": USER_ID,
            "type": type.rawValue
        ]
        values["tweetID"] = tweet.tweetID
        REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        let uid = USER_ID
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                    guard let uid = dictionary["uid"] as? String else { return }
                    
                    UserService.shared.fetchUser(uid: uid) { user in
                        let notification = Notification(user: user, tweet: nil, dictionary: dictionary)
                        notifications.append(notification)
                        completion(notifications)
                    }
                }
            } else {
                completion(notifications)
            }
        }
        
    }
}
