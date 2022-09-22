//
//  searchData.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import Foundation

class dataManager {
    static let shared: dataManager = dataManager()
    var searchResultOfNaver: SearchResultOfNaver?
    
    private init () {
    }
}

struct SearchResultOfNaver: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    var items: [BookInfo]
    
    struct BookInfo: Codable {
        let title: String
        let link: String
        let image: String
        let author: String
        let discount: String
        let publisher: String
        let pubdate: String
        let isbn: String
        let description: String
    }
}
