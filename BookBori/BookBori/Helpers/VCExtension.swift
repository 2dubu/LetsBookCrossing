//
//  Alert.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert1(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        
        defaultAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 2개의 버튼을 가진 Alert (buttonTitle2는 cancelAction의 이름)
    func showAlert2(title: String, message: String, buttonTitle1: String, buttonTitle2: String, handler: ((UIAlertAction) -> Swift.Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle1, style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: buttonTitle2, style: .cancel, handler: nil)
        
        defaultAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 신청 불가 도서
    func checkApplicableAndShowAlert(bookPK: Int) {
        // 네트워크 체킹
        getIsApplicableBook(bookPK: bookPK) {
            if SeoulBookBogoDataManager.shared.isApplicableBook?.data.canApply == false {
                self.showAlert1(title: "신청 불가", message: "갑자기 다른 사람이 이 책 신청 완료하여 안타깝게 됐음.", buttonTitle: "확인", handler: nil)
            }
        }
    }
}
