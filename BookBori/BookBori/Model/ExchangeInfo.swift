//
//  ExchangeInfo.swift
//  BookBori
//
//  Created by 이로운 on 2022/09/20.
//

// 1. 서버와의 교류 없이 앱에서만 쓰이는 데이터인가?
// 2. 다른 객체에서 얻을 수 있는 정보는 아닌가?
// -> 1, 2번에 해당되지 않는 변수만 남기기

import Foundation

var userSelectRegistrationMethodButton : String?

var bookRegister : Book?

var userPhoneNumber : String?
var userPassword : String?

// 다른 객체에서 얻을 수 있지만, 따로 저장하는 방법이 좋을 것 같아 예외적으로 남김
var applyBookPK : String?
var applyBookTitle : String?
var applyBookImgURL : String?

