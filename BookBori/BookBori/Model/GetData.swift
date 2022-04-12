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
    var isApplicableBook: IsApplicableBook?
    var appliedBookInfo: AppliedBookInfo?
    var isApplicableUser: IsApplicableUser?
    
    private init () {
    }
}

struct Header: Codable {
    let resultCode: Int
    let resultMessage: String
}

//MARK: - SelectBookVC

struct ApplicableBookList: Codable {
    let header: Header
    let data: BookListData
}

struct BookListData: Codable {
    let listCount: Int
    let nextPage: String
    let bookList: [BookData]
}

struct BookData: Codable {
    let imgUrl: String
    let bookTitle: String
    let bookPK: String
}

func getApplicableBookList(pagesize: Int, page: Int, keyword: String, completion: @escaping ()->()) {
    let baseURL = "https://gschool.fortune8282.co.kr/bookList.asp?pagesize=\(pagesize)&page=\(page)&keyword="
    let encodingKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = baseURL + "\(encodingKeyword ?? "")"
    
    // HTTP Request
    AF.request(url).responseJSON { (response) in
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

//MARK: - IsApplicableBook

struct IsApplicableBook: Codable {
    let header: Header
    let data: isApplicableBookData
}

struct isApplicableBookData: Codable {
    let canApply: Bool
}

func getIsApplicableBook(bookPK: Int, completion: @escaping ()->()) {
    let url = "https://gschool.fortune8282.co.kr/isAppBook.asp?bookPK=\(bookPK)"
    
    // HTTP Request
    AF.request(url).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(IsApplicableBook.self, from: jsonData)
                
                SeoulBookBogoDataManager.shared.isApplicableBook = json
                print("succes!", SeoulBookBogoDataManager.shared.isApplicableBook)
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

//MARK: - GuideVC

struct AppliedBookInfo: Codable {
    let header: Header
    let data: AppliedBookData // 이름 수정
}

struct AppliedBookData: Codable { // 이름 수정
    let writer: String
    let pubDate: Date
    let publisher: Date
}

func getAppliedBookInfo(bookPK: Int, completion: @escaping ()->()) {
    let urlString = ""
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(AppliedBookInfo.self, from: jsonData)

                SeoulBookBogoDataManager.shared.appliedBookInfo = json
                print("succes!", SeoulBookBogoDataManager.shared.appliedBookInfo)
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

//MARK: - CollectUserInfoVC

struct IsApplicableUser: Codable {
    let header: Header
    let data: IsApplicableUserData
}

struct IsApplicableUserData: Codable {
    let canApply: Bool
}

func getIsApplicableUser(phoneNum: String, completion: @escaping ()->()) {
    let urlString = ""
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(IsApplicableUser.self, from: jsonData)

                SeoulBookBogoDataManager.shared.isApplicableUser = json
                print("succes!", SeoulBookBogoDataManager.shared.isApplicableUser)
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


