//
//  LabelExtension.swift
//  BookBori
//
//  Created by 이건우 on 2021/10/20.
//

import Foundation
import UIKit

extension UILabel {
  func dynamicFont(fontSize size: CGFloat) {
    let currentFontName = self.font.fontName
    let height = UIScreen.main.bounds.size.height
    
    switch height {
    case 480.0: //Iphone 3,4S => 3.5 inch
      self.font = UIFont(name: currentFontName, size: size * 0.7)
      break
    case 568.0: //iphone 5, SE => 4 inch
      self.font = UIFont(name: currentFontName, size: size * 0.85)
      break
    case 667.0: //iphone 6, 6s, 7, 8 => 4.7 inch
      self.font = UIFont(name: currentFontName, size: size * 0.92)
      break
    case 736.0: //iphone 6s+ 6+, 7+, 8+ => 5.5 inch
      self.font = UIFont(name: currentFontName, size: size * 0.95)
      break
    case 812.0: //iphone X, XS => 5.8 inch
      self.font = UIFont(name: currentFontName, size: size)
      break
    case 896.0: //iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch
      self.font = UIFont(name: currentFontName, size: size * 1.15)
      break
    default:
      print("not an iPhone")
      break
    }
  }

}
