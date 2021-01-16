//
//  YourBooksVC.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit
import FirebaseAuth

class YourBooksVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var yourBooks: [Book] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Book>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        yourBooks.removeAll()
        NetworkManager.shared.getYourBooks {[weak self] (books) in
            guard let self = self else { return }
            
            for book in books {
                if book.userID == Auth.auth().currentUser!.uid {
                    self.yourBooks.append(book)
                }
            }
            self.updateData(on: self.yourBooks)
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(YourBooksCollectionCell.self, forCellWithReuseIdentifier: YourBooksCollectionCell.reuseID)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, book) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourBooksCollectionCell.reuseID, for: indexPath) as! YourBooksCollectionCell
            cell.set(book: book)
            return cell
        })
    }
    
    func updateData(on books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped() {
        let addBookVC = AddBookVC()
        addBookVC.delegate = self
        present(addBookVC, animated: true)
    }
}

extension YourBooksVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension YourBooksVC: AddBookVCDelegate {
    
    func didAddBook() {
        yourBooks.removeAll()
        NetworkManager.shared.getYourBooks {[weak self] (books) in
            guard let self = self else { return }
            
            for book in books {
                if book.userID == Auth.auth().currentUser!.uid {
                    self.yourBooks.append(book)
                }
            }
            self.updateData(on: self.yourBooks)
        }
    }
    
}
