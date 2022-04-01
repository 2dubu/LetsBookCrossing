//
//  CheckTableViewCell.swift
//  BookBori
//
//  Created by 이로운 on 2022/04/01.
//

import UIKit

class CheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var whiteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
