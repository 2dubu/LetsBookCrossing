import UIKit

let backgroundColor = #colorLiteral(red: 0.9164561629, green: 0.9865347743, blue: 0.8901466727, alpha: 1)
let tintColor = #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)

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
    image?.layer.masksToBounds = false
}

func setViewShadow(view: UIView?, shadowRadius: CGFloat?, shadowOpacity: Float?) {
    view?.layer.shadowOpacity = shadowOpacity ?? 0
    view?.layer.shadowColor = UIColor.gray.cgColor
    view?.layer.shadowOffset = .zero
    view?.layer.shadowRadius = shadowRadius ?? 0
}

