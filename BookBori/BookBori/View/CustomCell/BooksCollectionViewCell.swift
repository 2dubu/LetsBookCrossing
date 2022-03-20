//
//  BooksCollectionViewCell.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/22.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        coverImageView.layer.masksToBounds = true
        setImageShadow(image: coverImageView, shadowRadius: 3, shadowOpacity: 0.2)
    }
}
