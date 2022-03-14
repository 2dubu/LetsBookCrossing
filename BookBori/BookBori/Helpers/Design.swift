//
//  Design.swift
//  BookBori
//
//  Created by 이건우 on 2022/03/14.
//

import Foundation
import UIKit

func setButtonShadow(button: UIButton?, shadowOpacity: Float?, shadowRadius: CGFloat?) {
    button?.layer.shadowOpacity = shadowOpacity ?? 0
    button?.layer.shadowColor = UIColor.black.cgColor
    button?.layer.shadowOffset = CGSize(width: 0, height: 0)
    button?.layer.shadowRadius = shadowRadius ?? 0
}

