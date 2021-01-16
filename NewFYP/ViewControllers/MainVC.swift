//
//  ViewController.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MainVC: UIViewController {
    
    let logoImageView = UIImageView()
    let phraseLabel = FYPTitleLabel(textAlignment: .center, fontSize: 20)
    let createAccountButton = FYPButton(backgroundColor: .systemBlue, title: "Create account")
    let signInButton = FYPButton(backgroundColor: .systemPink, title: "Sign In")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        layoutUI()
        
//        let ref = Firestore.firestore().collection("/books/newBook/userBooks")
//        ref.addSnapshotListener { (snapshot, _) in
//            guard let snapshot = snapshot else { return }
//
//            for doc in snapshot.documents {
//                print(doc.documentID)
//            }
//        }
//        let r = Firestore.firestore().document("/books/newBook/userBooks/isbnID")
//        r.addSnapshotListener { (s, _) in
//            guard let s = s else { return }
//            print(s.data())
//        }
//        NetworkManager.shared.addBook(book: Book(title: "si", author: "Georges", edition: "1", price: "50,000", condition: "Good", userID: "17", isbn: "1234543", imageURL: "yes.jpg"))
//        NetworkManager.shared.downloadBookCover(isbn: "9781433202476", completion: { (image) in
//            guard let image = image else { return }
//            DispatchQueue.main.async {
//                self.logoImageView.image = image
//            }
//        })
//        NetworkManager.shared.getBookIsbn(title: "1984") { (isbn) in
//            guard let isbn = isbn else { return }
//            print(isbn)
//        }
//
//        NetworkManager.shared.getLibraryBooks { (string) in
////            guard let string = string else { return }
//            print(string)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        title = "Home"
    }

    func layoutUI() {
        view.addSubviews(logoImageView, phraseLabel, createAccountButton, signInButton)
        
        logoImageView.image = Images.fypLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        phraseLabel.text = "Buy and sell used books on the fly!"
        
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            
            phraseLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            phraseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phraseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phraseLabel.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            
            createAccountButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -20),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            createAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4)
        ])
    }
    
    @objc func createAccountButtonTapped() {
//        modalPresentationStyle = .overFullScreen
//        let tabBarController = FYPTabBarController()
//        show(tabBarController, sender: self)
        let createAccountVC = CreateAccountVC()
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
    
    @objc func signInButtonTapped() {
        let signInVC = SignInVC()
        navigationController?.pushViewController(signInVC, animated: true)
    }

}

