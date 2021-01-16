//
//  FYPError.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/11/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import Foundation

enum FYPError: String, Error {
    case invalidIsbn = "This isbn created an invalid request. Please try another."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
