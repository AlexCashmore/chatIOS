//
//  CustomTextField.swift
//  FireChat
//
//  Created by Aider  on 21/09/20.
//  Copyright © 2020 Aider . All rights reserved.
//

import Foundation
import UIKit

class CustomTextField : UITextField{
    
    init(placeholder:String){
        super.init(frame: .zero)
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string:placeholder,attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        textColor = .white
    }
    
    required init?(coder: NSCoder){
           fatalError("init(coder:) has not been implemented")
       }

}
