//
//  Registration.swift
//  MyFundooNote
//
//  Created by admin on 30/04/22.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullName?.isEmpty == false
            && userName?.isEmpty == false
    }
}
