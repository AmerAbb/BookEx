//
//  FYPCoverImageView.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class FYPCoverImageView: UIImageView {
    
    let placeholderImage = Images.coverPlaceholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        layer.cornerRadius = 5
        image = placeholderImage
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadCoverImage(isbn: String) {
        NetworkManager.shared.getBookInfoFromAPI(isbn: isbn) { (result) in
            switch result {
            case .success(let book):
                if book.covers != nil {
                    NetworkManager.shared.downloadBookCover(isbn: isbn) {[weak self] image in
                        guard let self = self else { return }
                        
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    func downloadUploadedImage(url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) {[weak self] (data, _, error) in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
}

