//
//  Book.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import Foundation

struct Book: Codable, Hashable {
    let title: String?
    let author: String?
    let edition: String?
    let price: String?
    let condition: String?
    let userID: String?
    let isbn: String?
    let imageURL: String?
    let imageData: Data?
    let covers: [Int]?
}
