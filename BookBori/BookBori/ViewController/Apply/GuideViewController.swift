//
//  GuideViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/23.
//

import UIKit

class GuideViewController: UIViewController {
    
    var checkButton1Tapped: Bool = false
    var checkButton2Tapped: Bool = false
    var checkButton3Tapped: Bool = false
    
    // MARK: - viewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBookAppliedInfo()
        dynamicFont()
        setViews()
        updateContinueButton()
        
        // button 초기 세팅
        continueButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        setButtonShadow(button: continueButton, shadowRadius: 3, shadowOpacity: 0.3)
        setImageShadow(image: bookCoverImageView, shadowRadius: 3, shadowOpacity: 0.7)
        ruleCheckImageView1.image = UIImage(named: "check")
        ruleCheckImageView2.image = UIImage(named: "check")
        ruleCheckImageView3.image = UIImage(named: "check")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
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
    
    @IBOutlet weak var ruleCheckImageView1: UIImageView!
    @IBOutlet weak var ruleCheckImageView2: UIImageView!
    @IBOutlet weak var ruleCheckImageView3: UIImageView!
    
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
        checkButton1Tapped.toggle()
        if checkButton1Tapped {
            ruleCheckImageView1.image = UIImage(named: "selected_check")
        } else {
            ruleCheckImageView1.image = UIImage(named: "check")
        }
        updateContinueButton()
    }
    
    @IBAction func ruleCheckButton2Tapped(_ sender: Any) {
        checkButton2Tapped.toggle()
        if checkButton2Tapped {
            ruleCheckImageView2.image = UIImage(named: "selected_check")
        } else {
            ruleCheckImageView2.image = UIImage(named: "check")
        }
        updateContinueButton()
    }
    
    @IBAction func ruleCheckButton3Tapped(_ sender: Any) {
        checkButton3Tapped.toggle()
        if checkButton3Tapped {
            ruleCheckImageView3.image = UIImage(named: "selected_check")
        } else {
            ruleCheckImageView3.image = UIImage(named: "check")
        }
        updateContinueButton()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        guard let applyBookPK = applyBookPK else { return }
        self.checkApplicable(bookPK: applyBookPK) {
            let collectUserInfoVC = UIStoryboard(name: "Apply", bundle: nil).instantiateViewController(withIdentifier: "CollectUserInfoVC")
            self.navigationController?.pushViewController(collectUserInfoVC, animated: true)
        }
    }
    
    // MARK: - function
    
    func dynamicFont() {
        bookTitleLabel.dynamicFont(fontSize: 17)
        authorLabel1.dynamicFont(fontSize: 13)
        authorLabel2.dynamicFont(fontSize: 12)
        publisherLabel1.dynamicFont(fontSize: 13)
        publisherLabel2.dynamicFont(fontSize: 12)
        pubDateLabel1.dynamicFont(fontSize: 13)
        pubDateLabel2.dynamicFont(fontSize: 12)
        
        ruleTitle.dynamicFont(fontSize: 22)
        ruleContents1.dynamicFont(fontSize: 15)
        ruleContents2.dynamicFont(fontSize: 15)
        ruleContents3.dynamicFont(fontSize: 15)
        
        continueButton.isEnabled = false
        continueButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        continueButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        continueButton.titleLabel?.dynamicFont(fontSize: 16)
    }
    
    func setBookAppliedInfo() {
        guard let book = bookApplied else { return }
        
        bookCoverImageView.kf.indicatorType = .activity
        bookCoverImageView.kf.setImage(
            with: URL(string: applyBookImgURL ?? "0"),
            placeholder: UIImage(named: "imageNotFound"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.7)),
                .cacheOriginalImage
            ])
        bookTitleLabel.text = applyBookTitle
        authorLabel2.text = book.author
        publisherLabel2.text = book.publisher
        pubDateLabel2.text = String(book.yearPublished)
    }
    
    func setViews() {
        whiteView1.layer.cornerRadius = 15
        whiteView1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        whiteView1.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView1.layer.borderWidth = 0.5
        setViewShadow(view: whiteView1, shadowRadius: 3, shadowOpacity: 0.3)
        
        whiteView2.layer.cornerRadius = 15
        whiteView2.backgroundColor = #colorLiteral(red: 0.9716641307, green: 0.9766351581, blue: 0.9722399116, alpha: 1)
        whiteView2.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView2.layer.borderWidth = 0.5
        setViewShadow(view: whiteView2, shadowRadius: 3, shadowOpacity: 0.3)
 
        bookInfoBGView.layer.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 1)
    }
    
    func updateContinueButton() {
        if checkButton1Tapped && checkButton2Tapped && checkButton3Tapped {
            continueButton.isEnabled = true
            continueButton.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.6156862745, blue: 0.3764705882, alpha: 1)
            continueButton.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            continueButton.isEnabled = false
            continueButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            continueButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
    }
}
