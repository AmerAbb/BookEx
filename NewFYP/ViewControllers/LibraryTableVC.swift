//
//  LibraryVC.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class LibraryTableVC: FYPLoadingVC {
    
    var tableView = UITableView()
    var books: [String] = []
    var filteredBooks: [String] = []
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .systemBlue
        view.backgroundColor = .systemBackground
        NetworkManager.shared.getLibraryBooks {[weak self] (titles) in
            guard let self = self else { return }
            guard let titles = titles else { return }
            
            self.books.removeAll()
            self.books = titles
            DispatchQueue.main.async {
                if !self.books.isEmpty {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.removeExcessCells()
        tableView.register(BooksTableCell.self, forCellReuseIdentifier: BooksTableCell.reuseID)
        tableView.frame = view.bounds
        tableView.rowHeight = 124
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a book"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}

extension LibraryTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return filteredBooks.count }
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableCell.reuseID, for: indexPath) as! BooksTableCell
        var bookTitle: String!
        if isSearching {
            bookTitle = filteredBooks[indexPath.row]
        } else {
            bookTitle = books[indexPath.row]
        }
        NetworkManager.shared.getBookIsbn(title: bookTitle) { isbn in
            guard let isbn = isbn else { return }
            cell.set(title: bookTitle, isbn: isbn)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        NetworkManager.shared.getSelectedBooks(title: books[indexPath.row]) { (books) in
//            print(books)
//        }
        let userBooksVC = UserBooksVC()
        userBooksVC.bookTitle = isSearching ? filteredBooks[indexPath.row] : books[indexPath.row]
//        userBooksVC.bookTitle = books[indexPath.row]
        navigationController?.pushViewController(userBooksVC, animated: true)
    }
}

extension LibraryTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, filter != "" else {
            filteredBooks.removeAll()
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredBooks = books.filter { $0.lowercased().contains(filter.lowercased()) }
        tableView.reloadData()
    }
}
