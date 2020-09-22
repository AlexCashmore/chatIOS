//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Aider  on 21/09/20.
//  Copyright © 2020 Aider . All rights reserved.
//

import Foundation



struct RegistrationViewModel : AuthenticationProtocol{
    var email: String?
    var password: String?
    var username: String?
    var fullname: String?
    
    var formIsValid: Bool{
          return email?.isEmpty==false && password?.isEmpty==false
            && fullname?.isEmpty==false && username?.isEmpty==false
      }
}
