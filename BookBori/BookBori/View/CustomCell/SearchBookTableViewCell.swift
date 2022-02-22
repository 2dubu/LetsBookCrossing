//
//  SearchBookTableViewCell.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit

class SearchBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookImageView.layer.masksToBounds = false
        bookImageView.layer.shadowRadius = 3
        bookImageView.layer.shadowOffset = .zero
        bookImageView.layer.shadowOpacity = 0.4
        bookImageView.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
