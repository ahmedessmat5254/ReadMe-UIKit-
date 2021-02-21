//
//  File.swift
//  ReadMe
//
//  Created by Ahmed Essmat on 14/02/2021.
//

import  UIKit

struct Book: Hashable {
    let title : String
    let author : String
    var readMe: Bool
    var review : String?
    var image : UIImage?
   
    static let mocBook = Book(title: "", author: "", readMe: true)
}

extension Book: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case review
        case readMe
    }
}

