//
//  LoginController.swift
//  FireChat
//
//  Created by Aider  on 21/09/20.
//  Copyright © 2020 Aider . All rights reserved.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

protocol AuthenticationControllerProtocol{
    func checkFormStatus()
}

class LoginController : UIViewController{
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    
    private lazy var passwordContainerView:InputContainerView  =  {
        return  InputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x"),textField: passwordTextField)
        
        
    }()
    
    private lazy var emailContainerView:InputContainerView  =  {
           return  InputContainerView(image:#imageLiteral(resourceName: "ic_mail_outline_white_2x"),textField: emailTextField)
           
           
       }()

    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    
     private let passwordTextField: CustomTextField = {
         let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
           return tf
     }()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.titleLabel?.textColor = .systemGray
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.isEnabled = false
        button.addTarget(self,action:#selector(handleLogin),for:.touchUpInside)
        button.setHeight(height: 50)

        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   " ,attributes:[.font:UIFont.systemFont(ofSize: 16),
                                                                                                       .foregroundColor:UIColor.white])
        
        attributedTitle.append(NSAttributedString(string:"Sign Up",
                                                  attributes: [.font:UIFont.boldSystemFont(ofSize: 16), .foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal
    )
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside )
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin(){
        print("debug handle login")
        guard let email = emailTextField.text else{ return}
        guard let password = passwordTextField.text else{ return}
        
        showLoader(true, withText: "Logging in")
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("Failed to log in with error \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
        print("Show sign up page...")
    }
    @objc func textDidChange(sender: UITextField){
        if sender === emailTextField{
            viewModel.email = sender.text
        }
        else{
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    //MARK: - Helpers
    
    func presentMainScreen(){
         DispatchQueue.main.async{
             let controller = ConversationsController()
             let nav = UINavigationController(rootViewController: controller)
             nav.modalPresentationStyle = .fullScreen
             self.present(nav,animated: true,completion: nil)
         }
     }

    
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:iconImage.bottomAnchor, left: view.leftAnchor, right:view.rightAnchor, paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left:view.leftAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor,right:view.rightAnchor,paddingLeft: 32,paddingBottom: 16,paddingRight:32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)


    }

    
    
}

extension LoginController:AuthenticationControllerProtocol{
    
    func checkFormStatus(){
        if viewModel.formIsValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        
    }
}
