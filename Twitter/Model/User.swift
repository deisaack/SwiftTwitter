//
//  User.swift
//  Twitter
//
//  Created by De Isaac on 7/9/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import Foundation


struct User {
    var fullname: String
    let email: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    var stats: UserRelationsStats?
    var bio: String?
    
    var isCurrentUser: Bool { return USER_ID == uid }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String

        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationsStats {
    var followers: Int
    var following: Int
}
