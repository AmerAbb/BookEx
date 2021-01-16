//
//  BooksTableCell.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/12/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class BooksTableCell: UITableViewCell {
    
    static let reuseID = "BooksTableCell"
    
    let coverImageView = FYPCoverImageView(frame: .zero)
    let titleLabel = FYPTitleLabel(textAlignment: .left, fontSize: 20)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String, isbn: String) {
        coverImageView.downloadCoverImage(isbn: isbn)
        titleLabel.text = title
    }
    
    private func configure() {
        addSubview(coverImageView)
        addSubview(titleLabel)
        accessoryType = .disclosureIndicator
        
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            coverImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            coverImageView.heightAnchor.constraint(equalToConstant: 100),
            coverImageView.widthAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}

