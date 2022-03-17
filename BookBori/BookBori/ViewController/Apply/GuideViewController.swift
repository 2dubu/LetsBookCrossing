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
        setWhiteViews()
        setButton()
    }
    
    // MARK: - IBOutlet & IBAction
    @IBOutlet weak var whiteView1: UIView!
    @IBOutlet weak var whiteView2: UIView!
    
    // 책 정보
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookInfoBGView: UIView!
    @IBOutlet weak var authorLabel1: UILabel!
    @IBOutlet weak var authorLabel2: UILabel!
    @IBOutlet weak var publisherLabel1: UILabel!
    @IBOutlet weak var publisherLabel2: UILabel!
    @IBOutlet weak var pubDateLabel1: UILabel!
    @IBOutlet weak var pubDateLabel2: UILabel!
    
    // 이용약관
    @IBOutlet weak var ruleTitle: UILabel!
    
    @IBOutlet weak var ruleContents1: UILabel!
    @IBOutlet weak var ruleContents2: UILabel!
    @IBOutlet weak var ruleContents3: UILabel!
    
    @IBOutlet weak var ruleCheckButton1: UIButton!
    @IBOutlet weak var ruleCheckButton2: UIButton!
    @IBOutlet weak var ruleCheckButton3: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ruleCheckButton1Tapped(_ sender: Any) {
    }
    
    @IBAction func ruleCheckButton2Tapped(_ sender: Any) {
    }
    
    @IBAction func ruleCheckButton3Tapped(_ sender: Any) {
    }
    
    // MARK: - function
    
    func dynamicFont() {
        bookTitleLabel.dynamicFont(fontSize: 15)
        authorLabel1.dynamicFont(fontSize: 13)
        authorLabel2.dynamicFont(fontSize: 13)
        publisherLabel1.dynamicFont(fontSize: 13)
        publisherLabel2.dynamicFont(fontSize: 13)
        pubDateLabel1.dynamicFont(fontSize: 13)
        pubDateLabel2.dynamicFont(fontSize: 13)
        
        ruleTitle.dynamicFont(fontSize: 18)
        ruleContents1.dynamicFont(fontSize: 13)
        ruleContents2.dynamicFont(fontSize: 13)
        ruleContents3.dynamicFont(fontSize: 13)
        
        continueButton.titleLabel?.dynamicFont(fontSize: 16)
    }
    
    func setBookAppliedInfo() {
        guard let book = bookApplied else { return }
        
        bookCoverImageView.image = UIImage(named: book.image)
        bookTitleLabel.text = book.title
        authorLabel2.text = book.author
        publisherLabel2.text = book.publisher
        pubDateLabel2.text = String(book.yearPublished)
    }
    
    func setWhiteViews() {
        whiteView1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        whiteView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        whiteView1.layer.cornerRadius = 20
        whiteView1.layer.shadowColor = UIColor.darkGray.cgColor
        whiteView1.layer.shadowOffset = CGSize(width: 0, height: 0)
        whiteView1.layer.shadowRadius = 2
        whiteView1.layer.shadowOpacity = 0.5
        
        whiteView2.layer.cornerRadius = 20
        whiteView2.layer.shadowColor = UIColor.darkGray.cgColor
        whiteView2.layer.shadowOffset = CGSize(width: 0, height: 0)
        whiteView2.layer.shadowRadius = 2
        whiteView2.layer.shadowOpacity = 0.5
        
        bookInfoBGView.layer.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 1)
    }
    
    func setButton() {
        continueButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        continueButton.layer.shadowColor = UIColor.darkGray.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        continueButton.layer.shadowRadius = 1
        continueButton.layer.shadowOpacity = 0.5
        continueButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        continueButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
}
