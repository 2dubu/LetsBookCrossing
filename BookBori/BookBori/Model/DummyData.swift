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
    var author : String
    var publisher : String
    var yearPublished : Int
}

class BookDummyData {
    static let shared = BookDummyData()
    
    var books : [Book] = [
        Book(title: "우주는 얼마나 넓을까?", image: "1", author: "미미" , publisher: "행복한 출판사" , yearPublished: 2000),
        Book(title: "글쓰기 잘 하는 아이는 이렇게 시작합니다", image: "2", author: "나나" , publisher: "멋진 출판사" , yearPublished: 2010),
        Book(title: "일 잘하는 사람은 단순하게 합니다", image: "1", author: "주주" , publisher: "귀여운 출판사" , yearPublished: 2011),
        Book(title: "생각 정리 습관", image: "2", author: "모모" , publisher: "아름다운 출판사" , yearPublished: 2013),
        Book(title: "생각 정리 습관", image: "2", author: "뿌뿌" , publisher: "완벽한 출판사" , yearPublished: 2018),
        Book(title: "생각 정리 습관", image: "2", author: "디디" , publisher: "최고의 출판사" , yearPublished: 2020),
        Book(title: "우주는 얼마나 넓을까?", image: "1", author: "미미" , publisher: "행복한 출판사" , yearPublished: 2000),
        Book(title: "글쓰기 잘 하는 아이는 이렇게 시작합니다", image: "2", author: "나나" , publisher: "멋진 출판사" , yearPublished: 2010),
        Book(title: "일 잘하는 사람은 단순하게 합니다", image: "1", author: "주주" , publisher: "귀여운 출판사" , yearPublished: 2011),
        Book(title: "생각 정리 습관", image: "2", author: "모모" , publisher: "아름다운 출판사" , yearPublished: 2013),
        Book(title: "생각 정리 습관", image: "2", author: "뿌뿌" , publisher: "완벽한 출판사" , yearPublished: 2018),
        Book(title: "생각 정리 습관", image: "2", author: "디디" , publisher: "최고의 출판사" , yearPublished: 2020),
        Book(title: "우주는 얼마나 넓을까?", image: "1", author: "미미" , publisher: "행복한 출판사" , yearPublished: 2000),
        Book(title: "글쓰기 잘 하는 아이는 이렇게 시작합니다", image: "2", author: "나나" , publisher: "멋진 출판사" , yearPublished: 2010),
        Book(title: "일 잘하는 사람은 단순하게 합니다", image: "1", author: "주주" , publisher: "귀여운 출판사" , yearPublished: 2011),
        Book(title: "생각 정리 습관", image: "2", author: "모모" , publisher: "아름다운 출판사" , yearPublished: 2013),
        Book(title: "생각 정리 습관", image: "2", author: "뿌뿌" , publisher: "완벽한 출판사" , yearPublished: 2018),
        Book(title: "생각 정리 습관", image: "2", author: "디디" , publisher: "최고의 출판사" , yearPublished: 2020)
    ]
}
