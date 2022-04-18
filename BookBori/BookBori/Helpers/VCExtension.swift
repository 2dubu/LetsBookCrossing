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
    func showAlert2(title: String, message: String, buttonTitle1: String, buttonTitle2: String, handler1: ((UIAlertAction) -> Swift.Void)?, handler2: ((UIAlertAction) -> Swift.Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle1, style: .default, handler: handler1)
        let cancelAction = UIAlertAction(title: buttonTitle2, style: .cancel, handler: handler2)
        
        defaultAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showServerErrorAlert() {
        showAlert1(title: "안내", message: "서버에 일시적인 오류가 발생했습니다\n잠시 후 다시 시도해주세요", buttonTitle: "확인", handler: nil)
    }
    
    // 신청 불가 도서
    func checkApplicable(bookPK: String, completion: @escaping () -> ()) {
        // 네트워크 체킹
        getIsApplicableBook(bookPK: bookPK) {
            if SeoulBookBogoDataManager.shared.isApplicableBook?.data.canApply == false {
                self.showAlert1(title: "안내", message: "이미 다른 사용자가 신청한 책입니다", buttonTitle: "다른 책 고르기") {_ in
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                completion()
            }
        } error: {
            self.showServerErrorAlert()
        }
    }
    
}
