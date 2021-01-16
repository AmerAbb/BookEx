//
//  AddBookVC.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/13/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

protocol AddBookVCDelegate: class {
    func didAddBook()
}

class AddBookVC: FYPLoadingVC {
    
    let isbnTextField = FYPTextField(placeholder: "Isbn")
    let authorTextField = FYPTextField(placeholder: "Author")
    let editionTextField = FYPTextField(placeholder: "Edition")
    let priceTextField = FYPTextField(placeholder: "Price eg: 30,000")
    let conditionTextField = FYPTextField(placeholder: "Condition")
    
    let imageUploaded = FYPCoverImageView(frame: .zero)
    
    let addImageButton = UIButton()
    let addBookButton = FYPButton(backgroundColor: .systemBlue, title: "Add book")
    
    var imageData = Data()
    
    weak var delegate: AddBookVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        addBookTapped()
    }
    
    func layoutUI() {
        view.addSubviews(addImageButton, isbnTextField, authorTextField, editionTextField, priceTextField, conditionTextField, addBookButton)
        
        addImageButton.layer.cornerRadius = 5
        addImageButton.setTitle("Add Image", for: .normal)
        addImageButton.backgroundColor = .lightGray
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        isbnTextField.delegate = self
        authorTextField.delegate = self
        editionTextField.delegate = self
        priceTextField.delegate = self
        conditionTextField.delegate = self
        
        addBookButton.addTarget(self, action: #selector(addBookTapped), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addImageButton.heightAnchor.constraint(equalToConstant: 130),
            addImageButton.widthAnchor.constraint(equalToConstant: 100),
            
            isbnTextField.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 10),
            isbnTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isbnTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            isbnTextField.heightAnchor.constraint(equalToConstant: 50),
            
            authorTextField.topAnchor.constraint(equalTo: isbnTextField.bottomAnchor, constant: 10),
            authorTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            authorTextField.heightAnchor.constraint(equalToConstant: 50),
            
            editionTextField.topAnchor.constraint(equalTo: authorTextField.bottomAnchor, constant: 10),
            editionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            editionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            priceTextField.topAnchor.constraint(equalTo: editionTextField.bottomAnchor, constant: 10),
            priceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            priceTextField.heightAnchor.constraint(equalToConstant: 50),
            
            conditionTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 10),
            conditionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            conditionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            conditionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addBookButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            addBookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addBookButton.heightAnchor.constraint(equalToConstant: 50),
            addBookButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4)
        ])
    }
    
    
    @objc func addImageTapped() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
//        imagePickerVC.allowsEditing = true
        present(imagePickerVC, animated: true)
    }
    
    @objc func addBookTapped() {
        guard isbnTextField.text != "", authorTextField.text != "", editionTextField.text != "", priceTextField.text != "", conditionTextField.text != "", addImageButton.currentBackgroundImage != nil else {
            return
        }
        
        NetworkManager.shared.getBookInfoFromAPI(isbn: isbnTextField.text!) {[weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let book):
                DispatchQueue.main.async {
                let title = book.title
                    let book = Book(title: title, author: self.authorTextField.text!, edition: self.editionTextField.text!, price: self.priceTextField.text, condition: self.conditionTextField.text!, userID: Auth.auth().currentUser?.uid, isbn: self.isbnTextField.text!, imageURL: "", imageData: self.imageData, covers: book.covers)
                NetworkManager.shared.addBook(book: book)
                    self.delegate.didAddBook()
                    self.dismiss(animated: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Error", message: "Failed to add book", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Retry", style: .cancel))
                    self.present(alertVC, animated: true)
                    return
                }
            }
        }
    }
}

extension AddBookVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addBookTapped()
        return true
    }
}

extension AddBookVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        let image2: Data = image.jpeg(.low)!
//        guard let imageData = image.pngData() else { return }
//        imageData = image.pngData()!
        imageData = image2
        
        addImageButton.setBackgroundImage(image, for: .normal)
        addImageButton.setTitle("", for: .normal)
//        let storage = Storage.storage().reference()
//        let ref = storage.child("images/no.png")
//        ref.putData(imageData, metadata: nil) { (_, error) in
//            guard error == nil else {
//                return
//            }
//            ref.downloadURL { (url, error) in
//                guard let url = url, error == nil else { return }
//                print(url)
//            }
//        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
