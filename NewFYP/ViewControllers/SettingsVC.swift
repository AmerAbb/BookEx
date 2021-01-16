//
//  SettingsVC.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {
    
    let oldPasswordTextField = FYPTextField(placeholder: "Old password")
    let newPasswordTextField = FYPTextField(placeholder: "New password")
    
    let signOutButton = FYPButton(backgroundColor: .systemPink, title: "Sign Out")
    let updatePasswordButton = FYPButton(backgroundColor: .systemBlue, title: "Update Password")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
//        Auth.auth().currentUser?.updatePassword(to: "1234567", completion: { (error) in
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    let alertVC = UIAlertController(title: "Error", message: "Failed to update password", preferredStyle: .alert)
//                    alertVC.addAction(UIAlertAction(title: "Retry", style: .cancel))
//                    self.present(alertVC, animated: true)
//                }
//                return
//            }
//        })
    }
    
    func layoutUI() {
        view.addSubviews(oldPasswordTextField, newPasswordTextField, signOutButton, updatePasswordButton)
        
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        updatePasswordButton.addTarget(self, action: #selector(updatePasswordButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            oldPasswordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            oldPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oldPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            oldPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordTextField.topAnchor.constraint(equalTo: oldPasswordTextField.bottomAnchor, constant: 20),
            newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            
            updatePasswordButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -20),
            updatePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updatePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            updatePasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4)
        ])
    }
    
    @objc func signOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            let mainVC = MainVC()
            tabBarController?.tabBar.isHidden = true
            show(mainVC, sender: self)
        } catch let error {
            print(error)
        }
    }
    
    @objc func updatePasswordButtonTapped() {
        
    }
    
}
