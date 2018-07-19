//
//  AccountApiRequestBuilder.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON

class AccountApiRequestBuilder {
    enum DomainType: Int {
        case Exmo = 1
        case Roobik = 2
    }
    
    enum ProcedureType: Int {
        case SignIn = 0
        case Logout = 1
        case ChangePassword = 3
        case SignUp = 4
    }
    
    static func buildSignUpRequest(email: String, firstName: String, lastName: String, login: String, password: String, exchangeDomain: DomainType) -> JSON {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "login": login,
            "password": password,
            "exchangeDomain": exchangeDomain.rawValue
        ]
    }
    
    static func buildLoginRequest(login: String, password: String, exchangeDomain: DomainType) -> JSON {
        return [
            "login": login,
            "password": password,
            "exchangeDomain": exchangeDomain.rawValue
        ]
    }
}
