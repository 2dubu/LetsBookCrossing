//
//  CompleteRegisterViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/23.
//

import UIKit

class CompleteRegisterViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var exchangedBookLabel: UILabel!
    @IBOutlet weak var seoulBookBogoLabel: UILabel!
    
    @IBOutlet weak var exchangedBookImageView: UIImageView!
    @IBOutlet weak var seoulBookBogoImageView: UIImageView!
    @IBOutlet weak var exchangedBookTitle: UILabel!
    @IBOutlet weak var seoulBookBogoBookTitle: UILabel!
    
    @IBOutlet weak var exchangeIcon: UIImageView!
    @IBOutlet var lineView: UIView!
    
    @IBOutlet weak var checkImageView1: UIImageView!
    @IBOutlet weak var description1: UILabel!
    @IBOutlet weak var checkImageView2: UIImageView!
    @IBOutlet weak var description2: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        dynamicFont()
        attribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationItem.hidesBackButton = true
    }
    
    //MARK: - IBAction
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        // 이때 에니메이션 스타일을 모달 내리는 것 처럼 하는 건 어떨까 고려
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is MainViewController {
                _ = self.navigationController?.popToViewController(vc as! MainViewController, animated: true)
            }
        }
    }
    
    //MARK: - Functions
    
    func setElements() {
        
        let fontsize : CGFloat = 10
        
        navigationItem.title = "도서 교환 정보"
        
        exchangedBookLabel.text = "등록한 도서"
        seoulBookBogoLabel.text = "신청한 도서"
        
        exchangeIcon.image = UIImage(systemName: "arrow.left.arrow.right")
        exchangedBookImageView.image = UIImage(named: bookApplied?.image ?? "")
        //seoulBookBogoImageView.image = UIImage(named: bookRegister?.image ?? "")
        seoulBookBogoImageView.image = UIImage(named: "1")
        
        exchangedBookTitle.text = bookApplied?.title
        seoulBookBogoBookTitle.text = bookRegister?.title
        
        lineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        checkImageView1.image = UIImage(systemName: "checkmark")
        checkImageView2.image = UIImage(systemName: "checkmark")
        
        description1.text = "신청이 완료되었습니다.\n서울책보고에 방문하신 후 \(calculateDate()) 오후 7시까지 교환을 완료하여 주시기 바랍니다.\n시간 내에 교환이 완료되지 않을 경우 자동으로 취소 처리됩니다."
        description2.text = "교환 취소를 원하실 경우 '북크로싱 신청 내역 조회'에서 취소할 수 있습니다."
        
        // comfirmButton 세팅
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        confirmButton.layer.shadowColor = UIColor.darkGray.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        confirmButton.layer.shadowRadius = 1
        confirmButton.layer.shadowOpacity = 0.5
        confirmButton.backgroundColor = .white
        confirmButton.tintColor = .black
    }
    
    func calculateDate() -> String {
        
        let date = Date()
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            dateFormatter.locale = Locale(identifier: "Ko_KR")
            
            return dateFormatter
        }()
        
        let calculatedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let formattedDate = dateFormatter.string(from: calculatedDate!)

        return formattedDate
    }
    
    func attribute() {
        
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 2
        
        // 책 제목 행간 조절
        let attrString1 = NSMutableAttributedString(string: exchangedBookTitle.text!)
        let attrString2 = NSMutableAttributedString(string: seoulBookBogoBookTitle.text!)
        attrString1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle1, range: NSMakeRange(0, attrString1.length))
        attrString2.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle1, range: NSMakeRange(0, attrString2.length))
        exchangedBookTitle.attributedText = attrString1
        seoulBookBogoBookTitle.attributedText = attrString2
    
        // 안내문 특정 문장 굵기 변경 & 행간 조절
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineSpacing = 4
        
        let attrString3 = NSMutableAttributedString(string: self.description1.text ?? "")
        attrString3.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: (self.description1.text! as NSString).range(of: "신청이 완료되었습니다."))
        attrString3.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .semibold), range: (self.description1.text! as NSString).range(of: "시간 내에 교환이 완료되지 않을 경우 자동으로 취소"))
        attrString3.addAttribute(.foregroundColor, value: UIColor.red, range: (self.description1.text! as NSString).range(of: "시간 내에 교환이 완료되지 않을 경우 자동으로 취소"))
        attrString3.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle2, range: NSMakeRange(0, attrString3.length))
        description1.attributedText = attrString3
        
        let attrString4 = NSMutableAttributedString(string: self.description2.text ?? "")
        attrString4.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle2, range: NSMakeRange(0, attrString4.length))
        description2.attributedText = attrString4
        
        exchangedBookTitle.textAlignment = .center
        seoulBookBogoBookTitle.textAlignment = .center
    }
    
    func dynamicFont() {
        exchangedBookLabel.dynamicFont(fontSize: 14)
        seoulBookBogoLabel.dynamicFont(fontSize: 14)
        exchangedBookTitle.dynamicFont(fontSize: 14)
        seoulBookBogoBookTitle.dynamicFont(fontSize: 14)
        
        description1.dynamicFont(fontSize: 14)
        description2.dynamicFont(fontSize: 14)
        
        confirmButton.titleLabel?.dynamicFont(fontSize: 18)
    }

}
