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
    let header: Header?
    let data: Data?
}

struct Header: Codable {
    let resultCode: Int
    let resultMessage: String
}

struct Data: Codable {
    let listCount: Int
    let nextPage: String
    var bookList: [BookData]
}

struct BookData: Codable {
    let imgUrl: String
    let bookTitle: String
    let bookPK: String
}

func getApplicableBookList(pagesize: Int, page: Int, keyword: String, completion: @escaping ()->()) {
    let urlString = "https://gschool.fortune8282.co.kr/bookList.asp?pagesize=\(pagesize)&page=\(page)&keyword=\(keyword)"
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(ApplicableBookList.self, from: jsonData)

                SeoulBookBogoDataManager.shared.applicableBookList = json
                print("succes!", SeoulBookBogoDataManager.shared.applicableBookList)
            } catch(let err) {
                print("err.localizedDescription", err.localizedDescription)
            }
            // 실패
        case .failure(let err):
            print(err.localizedDescription, "실패")
        }
        completion()
    }
}
