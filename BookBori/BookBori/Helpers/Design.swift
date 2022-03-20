//
//  Design.swift
//  BookBori
//
//  Created by 이건우 on 2022/03/14.
//

import Foundation
import UIKit

// 0.4, 2
func setButtonShadow(button: UIButton?, shadowRadius: CGFloat?, shadowOpacity: Float?) {
    button?.layer.shadowOpacity = shadowOpacity ?? 0
    button?.layer.shadowColor = UIColor.gray.cgColor
    button?.layer.shadowOffset = .zero
    button?.layer.shadowRadius = shadowRadius ?? 0
}

func setImageShadow(image: UIImageView?, shadowRadius: CGFloat?, shadowOpacity: Float?) {
    image?.layer.shadowOpacity = shadowOpacity ?? 0
    image?.layer.shadowColor = UIColor.gray.cgColor
    image?.layer.shadowOffset = .zero
    image?.layer.shadowRadius = shadowRadius ?? 0
}

func setViewShadow(view: UIView?, shadowRadius: CGFloat?, shadowOpacity: Float?) {
    view?.layer.shadowOpacity = shadowOpacity ?? 0
    view?.layer.shadowColor = UIColor.gray.cgColor
    view?.layer.shadowOffset = .zero
    view?.layer.shadowRadius = shadowRadius ?? 0
}

