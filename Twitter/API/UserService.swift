//
//  UserService.swift
//  Twitter
//
//  Created by De Isaac on 7/9/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit
import Firebase

typealias DBCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DBCompletion)) {
        let currentUserId = USER_ID
        REF_USER_FOLLOWING.child(currentUserId).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUserId: 1], withCompletionBlock: completion)
        }
        
    }
    
    func unFollowUser(uid: String, completion: @escaping(DBCompletion)) {
        let currentUserId = USER_ID
        REF_USER_FOLLOWING.child(currentUserId).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUserId).removeValue(completionBlock: completion)
        }
        
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        let currentUserId = USER_ID
        REF_USER_FOLLOWING.child(currentUserId).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationsStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let followings = snapshot.children.allObjects.count
                let stats = UserRelationsStats(followers: followers, following: followings)
                completion(stats)
            }
        }
    }
    
    func saveUserData(user: User, completion: @escaping(DBCompletion)) {
        let uid = USER_ID
        let values: [String : String] = [
            "fullname": user.fullname,
            "username": user.username,
            "bio": user.bio ?? ""
        ]
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping(URL?) -> Void ) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            return
        }
        let uid = USER_ID
        let fileName = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(fileName)
        
        ref.putData(imageData, metadata: nil) { (meta, err) in
            ref.downloadURL { (url, err) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageUrl": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    func fetchUser(withUsername username: String, completion: @escaping(User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
}
