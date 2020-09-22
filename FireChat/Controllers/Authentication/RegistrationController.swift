//
//  RegistrationController.swift
//  FireChat
//
//  Created by Aider  on 21/09/20.
//  Copyright © 2020 Aider . All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegistrationController : UIViewController{
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for:.normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var passwordContainerView:InputContainerView  =  {
         return  InputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x"),textField: passwordTextField)
         
         
     }()
     
     private lazy var emailContainerView:InputContainerView  =  {
            return  InputContainerView(image:#imageLiteral(resourceName: "ic_mail_outline_white_2x"),textField: emailTextField)
            
            
        }()
    
    
      private lazy var fullnameContainerView:InputContainerView  =  {
             return  InputContainerView(image:#imageLiteral(resourceName: "ic_person_outline_white_2x"),textField: fullnameTextField)
             
             
         }()
    
    
      private lazy var usernameContainerView:InputContainerView  =  {
             return  InputContainerView(image:#imageLiteral(resourceName: "ic_person_outline_white_2x"),textField: usernameTextField)
             
             
         }()

     
     private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let usernameTextField = CustomTextField(placeholder: "Username")
     
     
      private let passwordTextField: CustomTextField = {
          let tf = CustomTextField(placeholder: "Password")
         tf.isSecureTextEntry = true
            return tf
      }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.textColor = .systemGray
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.setHeight(height: 50)
        
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)

        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   " ,attributes:[.font:UIFont.systemFont(ofSize: 16),
                                                                                                       .foregroundColor:UIColor.white])
        
        attributedTitle.append(NSAttributedString(string:"Log In",
                                                  attributes: [.font:UIFont.boldSystemFont(ofSize: 16), .foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal
    )
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside )
        return button
    }()
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Selectors
    
    @objc func handleRegistration(){
        guard let email = emailTextField.text else{ return}
        guard let fullname = fullnameTextField.text else{ return}

        guard let username = usernameTextField.text?.lowercased() else{ return}

        guard let password = passwordTextField.text else{ return}
        
        guard let profileImage = profileImage else{return}
        
        self.showLoader(true, withText: "Signing up")
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error{
                print("debug \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
    
        }
        }
        
    
    
    @objc func handleSelectPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController,animated: true,completion: nil)
    }
       @objc func textDidChange(sender: UITextField){
        if sender === emailTextField{
            viewModel.email = sender.text
        }
        else if sender === usernameTextField{
            viewModel.username = sender.text
        }
        else if sender === fullnameTextField{
            viewModel.fullname = sender.text
        }
        else{
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    //MARK: - Helpers
    
    
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
            plusPhotoButton.centerX(inView: view)
            plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
            plusPhotoButton.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,fullnameContainerView,usernameContainerView,passwordContainerView,signupButton])
               
               stack.axis = .vertical
               stack.spacing = 16
               
               view.addSubview(stack)
               stack.anchor(top:plusPhotoButton.bottomAnchor, left: view.leftAnchor, right:view.rightAnchor, paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left:view.leftAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor,right:view.rightAnchor,paddingLeft: 32,paddingBottom: 16,paddingRight: 32)
        


               
    }
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        
        
    }
    
}

extension RegistrationController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor(white:1, alpha:0.7).cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 100 / 2
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
}

extension RegistrationController:AuthenticationControllerProtocol{
    
    func checkFormStatus(){
        if viewModel.formIsValid{
            signupButton.isEnabled = true
            signupButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        else{
            signupButton.isEnabled = false
            signupButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        
    }
}
