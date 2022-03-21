//
//  GetData.swift
//  BookBori
//
//  Created by 이건우 on 2022/03/20.
//

import Foundation
import Alamofire

class SeoulBookBogoDataManager {
    static let shared: SeoulBookBogoDataManager = SeoulBookBogoDataManager()
    var applicableBookList: ApplicableBookList?
    
    private init () {
    }
}

struct ApplicableBookList: Codable {
    var bookList: [BookInfo]
}

struct BookInfo: Codable {
    let bookNo: String
    let imgUrl: String
    let bookTitle: String
    let author: String
    let publisher: String
    let publicationDate: String
    let isbnNo: String
}
    
let urlString = "https://gschool.fortune8282.co.kr/booklist_json.asp"

func getBookList() {
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(ApplicableBookList.self, from: jsonData)

                SeoulBookBogoDataManager.shared.applicableBookList = json
            } catch(let err) {
                print(err.localizedDescription)
            }
            // 실패
        case .failure(let err):
            print(err.localizedDescription, "실패")
        }
    }
}
