//
//  MainViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var bookCrossingLabel: UILabel!
    
    @IBOutlet weak var howToUseButton: UIButton!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var FAQButton: UIButton!
    
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
    }
    
    //MARK: - IBAction
    @IBAction func applyButtonTapped(_ sender: Any) {
        let applySB = UIStoryboard(name: "Apply", bundle: nil)
        let selectBookVC = applySB.instantiateViewController(withIdentifier: "SelectBookVC")
        self.navigationController?.pushViewController(selectBookVC, animated: true)
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        let checkSB = UIStoryboard(name: "Check", bundle: nil)
        let checkVC = checkSB.instantiateViewController(withIdentifier: "CheckVC")
        self.navigationController?.pushViewController(checkVC, animated: true)
    }
    
    @IBAction func howToUseButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Functions

    func setButtons() {
        
        // 테두리 설정
        applyButton.layer.borderWidth = 1
        checkButton.layer.borderWidth = 1
        applyButton.layer.borderColor = UIColor.black.cgColor
        checkButton.layer.borderColor = UIColor.black.cgColor
        
        applyButton.layer.cornerRadius = 24
        checkButton.layer.cornerRadius = 24
        applyButton.layer.maskedCorners = CACornerMask.layerMinXMinYCorner // 좌측 상단
        checkButton.layer.maskedCorners = CACornerMask.layerMaxXMaxYCorner // 우측 하단
        
        // 텍스트 및 이미지 설정
        applyButton.titleLabel?.textColor = .black
        checkButton.titleLabel?.textColor = .black
        
        // notice & FAQ 버튼
        noticeButton.layer.cornerRadius = 8
        FAQButton.layer.cornerRadius = 8
        noticeButton.titleLabel?.font =  UIFont(name: "GmarketSansMedium", size: 20)
        FAQButton.titleLabel?.font =  UIFont(name: "GmarketSansMedium", size: 20)
    }
}
