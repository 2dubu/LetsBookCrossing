//
//  HowToUserViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/03/29.
//

import UIKit

class HowToUserViewController: UIViewController {
    
    @IBOutlet weak var whiteView1: UIView!
    @IBOutlet weak var howToUseImageView: UIImageView!
    @IBOutlet weak var bookcrossingLabel: UILabel!
    @IBOutlet weak var bookcrossingDescriptionLabel: UILabel!
    @IBOutlet weak var seoulBookbogoLabel: UILabel!
    @IBOutlet weak var seoulBookbogoDescriptionLabel: UILabel!
    
    @IBOutlet weak var wayToParticipateTItleLabel: UILabel!
    @IBOutlet weak var whiteView2: UIView!
    @IBOutlet weak var afterApplyLabel: UILabel!
    @IBOutlet weak var afterApplyDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
        
        setWhiteView()
        dynamicFont()
        applyAttribute()
    }
    
    func setWhiteView() {
        whiteView1.layer.cornerRadius = 15
        whiteView1.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView1.layer.borderWidth = 0.5
        setViewShadow(view: whiteView1, shadowRadius: 3, shadowOpacity: 0.3)
        
        whiteView2.layer.cornerRadius = 13
        whiteView2.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView2.layer.borderWidth = 0.5
        setViewShadow(view: whiteView2, shadowRadius: 3, shadowOpacity: 0.3)
        
        howToUseImageView.layer.cornerRadius = 13
    }
    
    func dynamicFont() {
        bookcrossingLabel.dynamicFont(fontSize: 20)
        bookcrossingDescriptionLabel.dynamicFont(fontSize: 16)
        seoulBookbogoLabel.dynamicFont(fontSize: 20)
        seoulBookbogoDescriptionLabel.dynamicFont(fontSize: 16)
        
        wayToParticipateTItleLabel.dynamicFont(fontSize: 22)
        afterApplyLabel.dynamicFont(fontSize: 22)
        afterApplyDescriptionLabel.dynamicFont(fontSize: 16)
    }
    
    func applyAttribute() {
        
        // afterApplyDescriptionLabel
        guard let text = self.afterApplyDescriptionLabel.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        // 특정 문자 굵기 변경
        guard let font = UIFont(name: "GmarketSansMedium", size: 16) else { return }
        attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: "신청 당일 또는 다음 날 운영 시간 이내"))
        attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: "안내 데스크에 문의"))
        self.afterApplyDescriptionLabel.attributedText = attributeString
        // 행간 간격 조절
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
        afterApplyDescriptionLabel.attributedText = attributeString
        // 중간 정렬
        afterApplyDescriptionLabel.textAlignment = .center
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
