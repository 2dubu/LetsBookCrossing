//
//  SearchBookTableViewCell.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit

class SearchBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel1: UILabel!
    @IBOutlet weak var bookAuthorLabel2: UILabel!
    @IBOutlet weak var bookCompanyLabel1: UILabel!
    @IBOutlet weak var bookCompanyLabel2: UILabel!
    @IBOutlet weak var bookDayLabel1: UILabel!
    @IBOutlet weak var bookDayLabel2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setImageShadow(image: bookImageView, shadowRadius: 3, shadowOpacity: 0.7)
        
        whiteView.layer.cornerRadius = 15
        whiteView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        whiteView.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView.layer.borderWidth = 0.5
        whiteView.layer.shadowRadius = 3
        whiteView.layer.shadowOffset = .zero
        whiteView.layer.shadowOpacity = 0.3
        whiteView.layer.shadowColor = UIColor.gray.cgColor
        
        grayView.layer.backgroundColor = #colorLiteral(red: 0.9716641307, green: 0.9766351581, blue: 0.9722399116, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
