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
    var appliedBookInfo: ApplyBookInfo?
    var isApplicableUser: IsApplicableUser?
    var exchangeInfo: ExchangeInfo?
    var detailExchangeInfo: DetailExchangeInfo?
    
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

func getApplicableBookList(pagesize: Int, page: Int, keyword: String, completion: @escaping ()->(), error: @escaping ()->()) {
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

                if SeoulBookBogoDataManager.shared.applicableBookList?.header.resultCode == 52000 {
                    error()
                }
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
    let data: IsApplicableBookData
}

struct IsApplicableBookData: Codable {
    let canApply: Bool
}

func getIsApplicableBook(bookPK: String, completion: @escaping ()->(), error: @escaping ()->()) {
    let url = "https://gschool.fortune8282.co.kr/isAppBook.asp?bookPK=\(bookPK)"
    
    // HTTP Request
    AF.request(url).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(IsApplicableBook.self, from: jsonData)
                
                SeoulBookBogoDataManager.shared.isApplicableBook = json
                if SeoulBookBogoDataManager.shared.applicableBookList?.header.resultCode == 52000 {
                    error()
                }
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

struct ApplyBookInfo: Codable {
    let header: Header
    let data: ApplyBookData // 이름 수정
}

struct ApplyBookData: Codable { // 이름 수정
    let writer: String
    let pubDate: String
    let publisher: String
    let comment: String
}

func getApplyBookInfo(bookPK: String, completion: @escaping ()->(), error: @escaping ()->()) {
    let urlString = "https://gschool.fortune8282.co.kr/bookGuide.asp?bookPK=\(bookPK)"
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(ApplyBookInfo.self, from: jsonData)

                SeoulBookBogoDataManager.shared.appliedBookInfo = json
                if SeoulBookBogoDataManager.shared.applicableBookList?.header.resultCode == 52000 {
                    error()
                }
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

func getIsApplicableUser(phoneNum: String, completion: @escaping ()->(), error: @escaping ()->()) {
    let urlString = "https://gschool.fortune8282.co.kr/CollectUserInfo.asp?phoneNumber=\(phoneNum)"
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(IsApplicableUser.self, from: jsonData)

                SeoulBookBogoDataManager.shared.isApplicableUser = json
                if SeoulBookBogoDataManager.shared.applicableBookList?.header.resultCode == 52000 {
                    error()
                }
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

//MARK: - CheckUserInfo

struct ExchangeInfo: Codable {
    var header: Header
    var data: ExchangeInfoData
}

struct ExchangeInfoData: Codable {
    var applyStatus: Bool
    var registerBookPK: String
    var applyBookPK: String
    var applyData: Date  // String인지 Date인지 잘 모름
}

func getExchangeInfo(phoneNum: String, password: String) {
    let urlString = ""
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(ExchangeInfo.self, from: jsonData)

                SeoulBookBogoDataManager.shared.exchangeInfo = json
                print("succes!", SeoulBookBogoDataManager.shared.exchangeInfo)
            } catch(let err) {
                print("err.localizedDescription", err.localizedDescription)
            }
            // 실패
        case .failure(let err):
            print(err.localizedDescription, "실패")
        }
    }
}

//MARK: - Check

struct DetailExchangeInfo: Codable {
    var header: Header
    var data: detailExchangeInfoData
}

struct detailExchangeInfoData: Codable {
    var registerBookImageURL: String
    var registerBookTitle: String
    var applyBookImgURL: String
    var applyBookTitle: String
}

func getDetailExchangeInfo(registerBookPK: String, applyBookPK: String) {
    let urlString = ""
    
    // HTTP Request
    AF.request(urlString).responseJSON { (response) in
        switch response.result {
        case .success(let res):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let json = try JSONDecoder().decode(DetailExchangeInfo.self, from: jsonData)

                SeoulBookBogoDataManager.shared.detailExchangeInfo = json
                print("succes!", SeoulBookBogoDataManager.shared.detailExchangeInfo)
            } catch(let err) {
                print("err.localizedDescription", err.localizedDescription)
            }
            // 실패
        case .failure(let err):
            print(err.localizedDescription, "실패")
        }
    }
}



