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
    class func returnAlert(title: String, msg: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        
        defaultAction.setValue(UIColor(#colorLiteral(red: 0.3294117647, green: 0.6156862745, blue: 0.3764705882, alpha: 1)), forKey: "titleTextColor")
        alertController.addAction(defaultAction)
        
        return alertController
    }
    
    // buttonTitle2 is cancelAction's title
    class func returnAlert2(title: String, msg: String, buttonTitle1: String, buttonTitle2: String, handler: ((UIAlertAction) -> Swift.Void)?) -> UIAlertController{
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle1, style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: buttonTitle2, style: .cancel, handler: nil)
        
        defaultAction.setValue(UIColor(#colorLiteral(red: 0.3294117647, green: 0.6156862745, blue: 0.3764705882, alpha: 1)), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(#colorLiteral(red: 0.3294117647, green: 0.6156862745, blue: 0.3764705882, alpha: 1)), forKey: "titleTextColor")
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
