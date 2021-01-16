//
//  NetworkManager.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/11/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class NetworkManager {
    
    private init() {}
    static let shared = NetworkManager()
    
    let cache = NSCache<NSString, UIImage>()
    
    func addBook(book: Book) {
//        Firestore.firestore().collection("/books").document("/newBook").collection("/userBooks").document("isbnID").setData(["title":"newBooks"])
        guard var title = book.title, let author = book.author, let edition = book.edition, let price = book.price, let condition = book.condition, let imageURL = book.imageURL, let userID = book.userID, let isbn = book.isbn, let imageData = book.imageData else {
            return
        }
        getBookInfoFromAPI(isbn: isbn) { result in
            switch result {
            case .success(let book):
                guard let bookTitle = book.title else { return }
                title = bookTitle
            case .failure(let error):
                print(error)
                return
            }
        }
        let storage = Storage.storage().reference()
        let ref = storage.child("images/\(isbn).png")
        ref.putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url, error == nil else { return }
                
                
                Firestore.firestore().collection("/books").document("/\(title)").collection("userBooks").document("/\(isbn)").setData(["title":title, "author": author, "edition": edition, "price": price, "condition": condition, "imageURL": url.absoluteString, "userID": userID, "isbn": isbn])
                Firestore.firestore().collection("/books").document("/\(title)").setData(["k": "k"])
                Firestore.firestore().collection("booksIsbn").document(title).setData(["isbn": book.isbn!])
                
                Firestore.firestore().collection("books2").document(isbn).setData(["title":title, "author": author, "edition": edition, "price": price, "condition": condition, "imageURL": url.absoluteString, "userID": userID, "isbn": isbn])
//                self.getYourBooks { (fetchedBooks) in
//                    let book = Book(title: title, author: author, edition: edition, price: price, condition: condition, userID: userID, isbn: isbn, imageURL: url.absoluteString, imageData: Data(), covers: [])
//                    var books = fetchedBooks
//                    books.append(book)
//                    Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData(["books" : books])
//                }
            }
        }

        
//        Firestore.firestore().collection("/books").document("/\(title)").collection("userBooks").document("/\(isbn)").setData(["title":title, "author": author, "edition": edition, "price": price, "condition": condition, "imageURL": imageURL, "userID": userID])
//        Firestore.firestore().collection("/books").document("/\(title)").setData(["k": "k"])
//        Firestore.firestore().collection("booksIsbn").document(title).setData(["isbn": book.isbn!])
    }
    
    func getLibraryBooks(completion: @escaping ([String]?) -> Void) {
        let ref = Firestore.firestore().collection("books")
        ref.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            
            var titles: [String] = []
            
            for document in snapshot.documents {
                titles.append(document.documentID)
            }
            completion(titles)
        }
    }
    
    //rename?
    func getSelectedBook(title: String, completion: @escaping ([Book]) -> Void) {
        let ref = Firestore.firestore().collection("/books/\(title)/userBooks")
        ref.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            
            var books: [Book] = []
            for document in snapshot.documents {
                let book = Book(title: document.data()["title"] as? String, author: document.data()["author"] as? String, edition: document.data()["edition"] as? String, price: document.data()["price"] as? String, condition: document.data()["condition"] as? String, userID: document.data()["userID"] as? String, isbn: document.data()["isbn"] as? String, imageURL: document.data()["imageURL"] as? String, imageData: nil, covers: nil)
                books.append(book)
            }
            completion(books)
        }
    }
    
    func getYourBooks(completion: @escaping ([Book]) -> Void) {
//        Firestore.firestore().collection("books").getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot, error == nil else { return }
//
//            var fetchedBooks: [Book] = []
//            for doc in snapshot.documents {
//                Firestore.firestore().collection("books").document(doc.documentID as! String).collection("userBooks").getDocuments { (snap, err) in
//                    guard let snap = snap, err == nil else { return }
//
//                    for document in snap.documents {
//                        print("yo")
//                        if document.data()["userID"] as! String == Auth.auth().currentUser!.uid {
//                            print("yoyo")
//                            let book = Book(title: document.data()["title"] as! String, author: document.data()["author"] as! String, edition: document.data()["edition"] as! String, price: document.data()["price"] as! String, condition: document.data()["condition"] as! String, userID: document.data()["userID"] as! String, isbn: document.data()["isbn"] as! String, imageURL: document.data()["imageURL"] as! String, imageData: Data(), covers: [])
//                            fetchedBooks.append(book)
//
//                        }
//                    }
//                }
//                completion(fetchedBooks)
//            }
//        }
        
        Firestore.firestore().collection("books2").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else { return }
            
            var fetchedBooks: [Book] = []
            
            for document in snapshot.documents {
                let book = Book(title: document.data()["title"] as! String, author: document.data()["author"] as! String, edition: document.data()["edition"] as! String, price: document.data()["price"] as! String, condition: document.data()["condition"] as! String, userID: document.data()["userID"] as! String, isbn: document.data()["isbn"] as! String, imageURL: document.data()["imageURL"] as! String, imageData: Data(), covers: [])
                fetchedBooks.append(book)
            }
            completion(fetchedBooks)
        }
        
    }
    
    func getBookIsbn(title: String, completion: @escaping (String?) -> Void) {
        let r = Firestore.firestore().collection("/booksIsbn").document("/\(title)")
        r.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            completion(data["isbn"] as? String)
        }
//        let ref = Firestore.firestore().collection("/books/\(title)/userBooks")
//        ref.addSnapshotListener { (snapshot, _) in
//            guard let snapshot = snapshot else { return }
//            completion(snapshot.documents[0].documentID)
//        }
    }
    
    func updateBook() {
        
    }
    
    func deleteBooks() {
        
    }
    
    func addUserInfo(user: User) {
        guard let name = user.name, let mail = user.mail, let phone = user.phone, let uid = user.uid, let books = user.books else { return }
        Firestore.firestore().collection("users").document(uid).setData(["name": name, "mail": mail, "phone": phone, "books": books])
    }
    
    func getUserInfo(completion: @escaping (User) -> Void) {
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { (snapshot, error) in
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            
            let user = User(name: data["name"] as! String, mail: data["mail"] as! String, phone: data["phone"] as! String, books: data["books"] as! [String], uid: Auth.auth().currentUser!.uid)
            completion(user)
        }
    }
    
    func getBookInfoFromAPI(isbn: String, completion: @escaping (Result<Book, FYPError>) -> Void) {
        guard let url = URL(string: "https://openlibrary.org/isbn/\(isbn).json") else {
            completion(.failure(.invalidIsbn))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let book = try JSONDecoder().decode(Book.self, from: data)
                completion(.success(book))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    func downloadBookCover(isbn: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: isbn)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-M.jpg") else {
            completion(nil)
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completion(nil)
                    return
            }
            self.cache.setObject(image, forKey: cacheKey)
            
            completion(image)
        }
        
        task.resume()
    }
}
