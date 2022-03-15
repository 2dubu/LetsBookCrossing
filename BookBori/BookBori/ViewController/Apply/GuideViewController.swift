//
//  GuideViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/23.
//

import UIKit

class GuideViewController: UIViewController {
    
    // MARK: - viewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBookAppliedInfo()
        dynamicFont()
        setButton()
        
        // 중간 line 세팅
        lineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    
    // MARK: - IBOutlet & IBAction
    
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDetailLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - function
    
    func dynamicFont() {
        bookTitleLabel.dynamicFont(fontSize: 16)
        bookDetailLabel.dynamicFont(fontSize: 13)
        continueButton.titleLabel?.dynamicFont(fontSize: 18)
    }
    
    func setBookAppliedInfo() {
        guard let book = bookApplied else { return }
        bookCoverImageView.image = UIImage(named: book.image)
        bookTitleLabel.text = book.title
        
        // bookDetailLabel 세팅
        bookDetailLabel.text = "저자 : \(book.author)\n출판사 : \(book.publisher)\n발행연도 : \(book.yearPublished)"
        let attrString = NSMutableAttributedString(string: bookDetailLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        bookDetailLabel.attributedText = attrString
    }
    
    func setButton() {
        continueButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        continueButton.layer.shadowColor = UIColor.darkGray.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        continueButton.layer.shadowRadius = 1
        continueButton.layer.shadowOpacity = 0.5
        continueButton.backgroundColor = .white
        continueButton.tintColor = .black
    }
}
