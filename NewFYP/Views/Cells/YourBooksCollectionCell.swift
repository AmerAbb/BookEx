//
//  YourBooksTableCell.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/14/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class YourBooksCollectionCell: UICollectionViewCell {
    
    static let reuseID = "YourBooksCollectionCell"
    
    let uploadedImageView = FYPCoverImageView(frame: .zero)
    let bookTitleLabel = FYPTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        uploadedImageView.image = nil
        bookTitleLabel.text = nil
        super.prepareForReuse()
    }
    
    func set(book: Book) {
        bookTitleLabel.text =  book.title!
        uploadedImageView.downloadUploadedImage(url: book.imageURL!)
    }
    
    
    func configure() {
        addSubviews(uploadedImageView, bookTitleLabel)
        
        NSLayoutConstraint.activate([
            uploadedImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            uploadedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            uploadedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            uploadedImageView.heightAnchor.constraint(equalTo: uploadedImageView.widthAnchor, multiplier: 1.5),
            
            bookTitleLabel.topAnchor.constraint(equalTo: uploadedImageView.bottomAnchor, constant: 12),
            bookTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bookTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}

