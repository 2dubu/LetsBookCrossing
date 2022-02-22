//
//  Alert.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import Foundation
import UIKit

// MARK: UtilitiesForAlert
class UtilitiesForAlert {
    
    // Alert Dialog
    class func showAlert(viewController: UIViewController?,title: String, msg: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        defaultAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
        alertController.addAction(defaultAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    // buttonTitle2 is cancelAction's title
    class func showAlert2(viewController: UIViewController?,title: String, msg: String, buttonTitle1: String, buttonTitle2: String, handler: ((UIAlertAction) -> Swift.Void)?){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle1, style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: buttonTitle2, style: .cancel, handler: nil)
        
        defaultAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
