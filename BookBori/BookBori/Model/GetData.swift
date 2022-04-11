//
//  GetData.swift
//  BookBori
//
//  Created by 이건우 on 2022/03/20.
//

import Foundation
import Alamofire

class DataManager {
    static let shared: DataManager = DataManager()
    
    var applicableBookList: ApplicableBookList?
    var isApplicableBook: IsApplicableBook?
    var infoApplyBook: InfoApplyBook?
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
    let header: Header?
    let data: BookListData?
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
    let urlString = "https://gschool.fortune8282.co.kr/bookList.asp?pagesize=\(pagesize)&page=\(page)&keyword=\(keyword)"
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(ApplicableBookList.self, from: jsonData)

                DataManager.shared.applicableBookList = json
                print("succes!", DataManager.shared.applicableBookList)
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
    let header: Header?
    let data: isApplicableBookData?
}

struct isApplicableBookData: Codable {
    let canApply: Bool
}

func getIsApplicableBook(bookPk: Int, completion: @escaping ()->()) {
    let urlString = ""
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(IsApplicableBook.self, from: jsonData)

                DataManager.shared.isApplicableBook = json
                print("succes!", DataManager.shared.isApplicableBook)
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

struct InfoApplyBook: Codable {
    let header: Header?
    let data: infoApplyData?
}

struct infoApplyData: Codable {
    let writer: String
    let pubDate: Date
    let publisher: Date
}

func getInfoApplyBook(bookPk: Int, completion: @escaping ()->()) {
    let urlString = ""
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(InfoApplyBook.self, from: jsonData)

                DataManager.shared.infoApplyBook = json
                print("succes!", DataManager.shared.infoApplyBook)
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
    let header: Header?
    let data: IsApplicableUserData?
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

                DataManager.shared.isApplicableUser = json
                print("succes!", DataManager.shared.isApplicableUser)
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


