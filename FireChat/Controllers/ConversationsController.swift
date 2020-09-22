//
//  ConversationsController.swift
//  FireChat
//
//  Created by Aider  on 21/09/20.
//  Copyright © 2020 Aider . All rights reserved.
//

import Foundation

import UIKit
import Firebase

class ConversationsController: UIViewController{
    private let reuseIdentifier = "ConversationCell";
    //MARK: - Properties
    
    private let tableView = UITableView()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }
    //MARK: - Selectors
    
    @objc func showProfile(){
        logout()
        
    }
    
    //MARK: - API
    func authenticateUser(){
        if Auth.auth().currentUser?.uid == nil{
            print("DEBUG User is not logged in, present login")
            presentLoginScreen()
        }
        else{
            print("User is logged in, \(Auth.auth().currentUser?.uid)")
        }
    }
    
    func logout(){
        do {
            print("DEBUG: logout")
            try Auth.auth().signOut()
            self.presentLoginScreen()
        }catch{
            print("DEBUG: error signing out")
        }
    }
    
    
    //MARK: - Helpers
    
    func presentLoginScreen(){
        DispatchQueue.main.async{
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav,animated: true,completion: nil)
        }
    }
    
 
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        configureTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
    }
    
    func configureTableView(){
         tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate=self
        tableView.dataSource=self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
     }
    
    func configureNavigationBar(){
        let appearance = UINavigationBarAppearance();
        appearance.configureWithOpaqueBackground();
        appearance.largeTitleTextAttributes=[.foregroundColor:UIColor.white]
        appearance.backgroundColor = .systemBlue
        navigationController?.navigationBar.standardAppearance=appearance
        navigationController?.navigationBar.compactAppearance=appearance
        navigationController?.navigationBar.scrollEdgeAppearance=appearance
        
        navigationController?.navigationBar.prefersLargeTitles=true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        
    }
}

extension ConversationsController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath)
        cell.textLabel?.text="Test Cell"
        return cell
        
    }
    
    
}
extension ConversationsController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
