//
//  EditProfileViewModel.swift
//  Twitter
//
//  Created by De Isaac on 7/16/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import Foundation


enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .username:
            return "Username"
        case .fullname:
            return "Name"
        case .bio:
            return "Bio"
        }
    }
}


class EditProfileViewModel {
    let option: EditProfileOptions
    private let user: User
    var shouldHideTextField : Bool {
        return option == .bio
    }
    var shouldHideTextView: Bool {
        return option != .bio
    }
    var titleText : String {
        return option.description
    }
    var optionValue : String {
        switch option {
        case .fullname:
            return user.username
        case .username:
            return user.fullname
        case .bio:
            return user.bio ?? ""
        }
    }
    
    init(user: User, option: EditProfileOptions) {
        self.option = option
        self.user = user
    }
}

