//
//  NotificationViewModel.swift
//  Twitter
//
//  Created by De Isaac on 7/13/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit


struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formarter = DateComponentsFormatter()
        formarter.allowedUnits  = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formarter.maximumUnitCount = 1
        formarter.unitsStyle = .abbreviated
        let now = Date()
        return formarter.string(from: notification.timestamp, to: now) ?? "2m"
    }
    
    var notificationMessage: String {
        switch type {
        case .follow:
            return " started following you"
        case .like:
            return " liked your tweet"
        case .reply:
            return " replied to your tweet"
        case .retweet:
            return " retweeted your tweet"
        case .mention:
            return " mentioned you in a tweet"
        }
    }
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else {
            return nil
        }
        let attributedString = NSMutableAttributedString(string: user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedString.append(NSAttributedString(string: notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attributedString.append(NSAttributedString(string: " \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        return attributedString
        
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
