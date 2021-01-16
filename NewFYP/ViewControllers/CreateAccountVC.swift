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
        configureViewController()
        layoutTextFields()
        layoutButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .systemBackground
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemBlue
        title = "Create account"
    }
    
    func layoutTextFields() {
        view.addSubviews(nameTextField, phoneTextField, emailTextField, passwordTextField, confirmationPasswordTextField)
        
        nameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmationPasswordTextField.delegate = self
        
        phoneTextField.keyboardType = .phonePad
        passwordTextField.isSecureTextEntry = true
        confirmationPasswordTextField.isSecureTextEntry = true
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmationPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            confirmationPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            confirmationPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func layoutButton() {
        view.addSubview(createAccountButton)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            createAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4)
        ])
    }
    
    @objc func createAccountButtonTapped() {
        guard nameTextField.text != "", emailTextField.text != "", phoneTextField.text != "", passwordTextField.text == confirmationPasswordTextField.text, passwordTextField.text != "" else { return }
        showLoadingView()
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
                let user = User(name: self.nameTextField.text!, mail: self.emailTextField.text!, phone: self.phoneTextField.text!, books: [], uid: Auth.auth().currentUser?.uid)
                NetworkManager.shared.addUserInfo(user: user)
                self.navigationController?.isNavigationBarHidden = true
                let tabBarController = FYPTabBarController()
                self.show(tabBarController, sender: self)
            }
        }
    }
}

extension CreateAccountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createAccountButtonTapped()
        return true
    }
}
