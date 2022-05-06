//
//  Login.swift
//  MyFundooNote
//
//  Created by admin on 30/04/22.
//

import Foundation
protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LogInViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}
