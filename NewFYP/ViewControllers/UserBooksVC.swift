//
//  UserBooksVC.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/14/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class UserBooksVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var books: [Book] = []
    var bookTitle: String!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Book>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        getBooks()
    }
    
    func getBooks() {
        NetworkManager.shared.getSelectedBook(title: bookTitle) {[weak self] (books) in
            guard let self = self else { return }
            
            self.books = books
            self.updateData(on: self.books)
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = bookTitle
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BooksCollectionCell.self, forCellWithReuseIdentifier: BooksCollectionCell.reuseID)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, book) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksCollectionCell.reuseID, for: indexPath) as! BooksCollectionCell
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
}


extension UserBooksVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
