//
//  BooksCollectionCell.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class BooksCollectionCell: UICollectionViewCell {
    
    static let reuseID = "BooksCollectionCell"
    
    let uploadedImageView = FYPCoverImageView(frame: .zero)
//    let bookConditionLabel = FYPTitleLabel(textAlignment: .left, fontSize: 16)
//    let bookPriceLabel = FYPTitleLabel(textAlignment: .left, fontSize: 16)
    let bookConditionLabel = FYPSecondaryTitleLabel(textAlignment: .left, fontSize: 14)
    let bookPriceLabel = FYPSecondaryTitleLabel(textAlignment: .left, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        uploadedImageView.image = nil
        bookConditionLabel.text = nil
        bookPriceLabel.text = nil
        super.prepareForReuse()
    }
    
    func set(book: Book) {
        bookConditionLabel.text = "Condition: \(book.condition!)"
        bookPriceLabel.text = "Price: \(book.price!) Lbp"
        uploadedImageView.downloadUploadedImage(url: book.imageURL!)
    }
    
    
    func configure() {
        addSubviews(uploadedImageView, bookPriceLabel, bookConditionLabel)
        
        NSLayoutConstraint.activate([
            bookConditionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bookConditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bookConditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bookConditionLabel.heightAnchor.constraint(equalToConstant: 16),
            
            bookPriceLabel.topAnchor.constraint(equalTo: bookConditionLabel.bottomAnchor, constant: 12),
            bookPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bookPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bookPriceLabel.heightAnchor.constraint(equalToConstant: 16),
            
            uploadedImageView.topAnchor.constraint(equalTo: bookPriceLabel.bottomAnchor, constant: 12),
            uploadedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            uploadedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            uploadedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

