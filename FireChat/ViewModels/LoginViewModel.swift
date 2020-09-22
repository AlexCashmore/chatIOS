//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Aider  on 21/09/20.
//  Copyright © 2020 Aider . All rights reserved.
//

import Foundation


protocol AuthenticationProtocol {
    var formIsValid: Bool {get}
}

struct LoginViewModel:AuthenticationProtocol{
    var email: String?
    var password: String?

    var formIsValid: Bool{
        return email?.isEmpty==false && password?.isEmpty==false
    }
    
    
}
