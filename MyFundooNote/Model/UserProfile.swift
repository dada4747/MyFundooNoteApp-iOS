//
//  UserProfile.swift
//  MyFundooNote
//
//  Created by admin on 05/05/22.
//

import Foundation
import Firebase
struct User {
    let uid             : String
    let profileImageUrl : String
    let username        : String
    let fullname        : String
    let email           : String
    
    init(dictionary: [String: Any]) {
        self.uid             = dictionary["uid"] as? String ?? ""
        self.fullname        = dictionary["fullname"] as? String ?? ""
        self.username        = dictionary["username"] as? String ?? ""
        self.email           = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
