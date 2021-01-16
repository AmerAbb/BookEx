//
//  CreateAcctountVC.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/12/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: FYPLoadingVC {
    
    let nameTextField = FYPTextField(placeholder: "Enter name")
    let phoneTextField = FYPTextField(placeholder: "Enter phone number")
    let emailTextField = FYPTextField(placeholder: "Enter email address")
    let passwordTextField = FYPTextField(placeholder: "Enter password")
    let confirmationPasswordTextField = FYPTextField(placeholder: "Confirm password")
    
    let createAccountButton = FYPButton(backgroundColor: .systemBlue, title: "Create account")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemBlue
        title = "Create account"
    }
    
    func layoutTextFields() {
        view.addSubviews(nameTextField, phoneTextField, emailTextField, passwordTextField, confirmationPasswordTextField)
        
        phoneTextField.keyboardType = .phonePad
        passwordTextField.isSecureTextEntry = true
        confirmationPasswordTextField.isSecureTextEntry = true
        
        NSLayoutConstraint.activate([
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmationPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmationPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            confirmationPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func layoutButton() {
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
    }
    
    @objc func createAccountButtonTapped() {
        showLoadingView()
        guard emailTextField.text != "", phoneTextField.text != "", passwordTextField.text == confirmationPasswordTextField.text, passwordTextField.text != "" else { return }
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {[weak self] (_, error) in
            guard let self = self else { return }
            self.dismissLoadingView()
            if error != nil {
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Retry", style: .cancel))
                    self.present(alertVC, animated: true)
                }
            } else {
                let tabBarController = FYPTabBarController()
                self.show(tabBarController, sender: self)
            }
        }
    }
}
