//
//  ResponseModel.swift
//  LiteNews
//
//  Created by Thanh Nguyen on 9/27/19.
//  Copyright © 2019 Thanh Nguyen. All rights reserved.
//

import Foundation

struct ResponseModel : Codable {
    var status: String
    var totalResults: Int
    let articles: [Article]
}

struct Article : Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
