//
//  SignInVC.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/12/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: FYPLoadingVC {
    
    let emailTextField = FYPTextField(placeholder: "Enter email address")
    let passwordTextField = FYPTextField(placeholder: "Enter password")
    let signInButton = FYPButton(backgroundColor: .systemPink, title: "Sign In")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
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
        title = "Sign In"
    }
    
    func layoutUI() {
        view.addSubviews(emailTextField, passwordTextField, signInButton)
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        passwordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4)
        ])
    }
    
    @objc func signInButtonTapped() {
        guard emailTextField.text != "", passwordTextField.text != "" else { return }
        showLoadingView()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (_, error) in
            self.dismissLoadingView()
            if error != nil {
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Retry", style: .cancel))
                    self.present(alertVC, animated: true)
                }
            } else {
                self.navigationController?.isNavigationBarHidden = true
                let tabBarController = FYPTabBarController()
                self.show(tabBarController, sender: self)
            }
        }
    }
}

extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signInButtonTapped()
        return true
    }
}
