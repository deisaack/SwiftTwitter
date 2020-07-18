//
//  UploadTweetViewModel.swift
//  Twitter
//
//  Created by De Isaac on 7/12/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit


enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}


struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    let shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
