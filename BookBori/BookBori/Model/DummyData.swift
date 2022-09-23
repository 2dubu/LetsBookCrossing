
import Foundation

// MARK: - ExchangeHistory Data
// TODO : 신청내역 조회 화면 데이터 연동 후 1) 더미데이터 삭제 2) ExchangeHistory 인스턴스 생성 

struct ExchangeHistory {
    var applyDate : String
    
    var registeredBookTitle: String
    var applieddBookTitle: String
    
    var registeredBookImage: String
    var applieddBookImage: String
}

class ExchangeHistoryDummyData {
    static let shared = ExchangeHistoryDummyData()
    
    var histories: [ExchangeHistory] = [
        ExchangeHistory(applyDate: "2022-03-14", registeredBookTitle: "왜 설탕은 달고 소금은 짤까", applieddBookTitle: "설탕과 소금의 충격적인 진실", registeredBookImage: "1", applieddBookImage: "2"),
        ExchangeHistory(applyDate: "2202-03-13", registeredBookTitle: "때때로 난 고양이에게 깔리고 싶다", applieddBookTitle: "난 강아지가 더 좋은걸", registeredBookImage: "2", applieddBookImage: "1")
    ]
}
