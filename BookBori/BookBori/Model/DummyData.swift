//
//  DummyData.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import Foundation


// Book Dummy Data

struct Book {
    var title : String
    var image : String
}

class BookDummyData {
    static let shared = BookDummyData()
    
    var books : [Book] = [
        Book(title: "우주는 얼마나 넓을까?", image: "1"),
        Book(title: "글쓰기 잘 하는 아이는 이렇게 시작합니다", image: "2"),
        Book(title: "일 잘하는 사람은 단순하게 합니다", image: "1"),
        Book(title: "생각 정리 습관", image: "2"),
        Book(title: "생각 정리 습관", image: "2"),
        Book(title: "생각 정리 습관", image: "2")
    ]
}
