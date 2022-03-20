//
//  ExchangeHistoryTableViewCell.swift
//  BookBori
//
//  Created by 이건우 on 2022/03/20.
//

import UIKit

class ExchangeHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var historyNumber: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var registeredBookLabel: UILabel!
    @IBOutlet weak var appliedBookLabel: UILabel!
    
    @IBOutlet weak var registeredBookImageView: UIImageView!
    @IBOutlet weak var appliedBookImageView: UIImageView!
    
    @IBOutlet weak var registeredBookTitleLabel: UILabel!
    @IBOutlet weak var appliedBookTitleLabel: UILabel!
    
    @IBOutlet weak var applyCancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        whiteView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        whiteView.layer.cornerRadius = 15
        whiteView.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView.layer.borderWidth = 0.5
        whiteView.layer.shadowRadius = 3
        whiteView.layer.shadowOffset = .zero
        whiteView.layer.shadowOpacity = 0.3
        whiteView.layer.shadowColor = UIColor.gray.cgColor
        
        applyCancelButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        applyCancelButton.layer.shadowColor = UIColor.darkGray.cgColor
        applyCancelButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        applyCancelButton.layer.shadowRadius = 1
        applyCancelButton.layer.shadowOpacity = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dynamicFont() {
        
        dateLabel.dynamicFont(fontSize: 14)
        registeredBookLabel.dynamicFont(fontSize: 18)
        appliedBookLabel.dynamicFont(fontSize: 18)
        registeredBookTitleLabel.dynamicFont(fontSize: 15)
        appliedBookTitleLabel.dynamicFont(fontSize: 15)
        
        applyCancelButton.titleLabel?.dynamicFont(fontSize: 17)
    }
    
    @IBAction func applyCancelButtonTapped(_ sender: Any) {
    }
    
}
