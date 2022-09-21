
import Foundation

class ExchangeDataManager {
    static let shared: ExchangeDataManager = ExchangeDataManager()
    
    // 책 등록 방식 구분
    var RegistrationMethod : RegistrationMethod?

    // 교환 완료 시 보낼 정보
    var bookRegister: Book?
    var userInfo: UserInfo?
    
    // GuideVC, CompleteRegistrationVC에서 표시할 신청책 정보 + PK를 통해 신청 가능한지 확인
    var applyBookInfo: ApplyBook?
    
    // TODO : sendData 함수 구현 (등록 완료 버튼 누를 시 실행)
    // TODO : resetData 함수 구현 (교환 정보 확인 후 실행)
}

struct Book {
    var title : String
    var imageData : Data
    var author : String
    var publisher : String
    var pubDate : Int
    var commnet: String
}

struct UserInfo {
    var phoneNumber: String
    var password: String
}

struct ApplyBook {
    var bookPK: String
    var title: String
    var imageURL: String
}

enum RegistrationMethod {
    case scanBarcode
    case seach
    case DirectInput
}


