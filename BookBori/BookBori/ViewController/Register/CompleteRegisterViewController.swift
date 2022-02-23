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
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        
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
        
        exchangedBookLabel.text = "교환 도서"
        seoulBookBogoLabel.text = "서울책보고"
        
        exchangedBookImageView.image = UIImage(named: "1")
        seoulBookBogoImageView.image = UIImage(named: "2")
        
        exchangedBookTitle.text = "고양이는 츄르를 좋아해"
        seoulBookBogoBookTitle.text = "강아지는 개껌을 좋아해"
        
        checkImageView.image = UIImage(systemName: "checkmark")
        descriptionTitle.text = "신청이 완료되었습니다."
        
        descriptionLabel1.text = """
        \(calculateDate()) 오후 7시까지 "서울책보고"에 방문하신 후 교환을 완료하여 주시기 바랍니다.
        시간 내에 교환이 완료되지 않을 경우 자동으로 취소 처리됩니다.
        """
        let attributedStr = NSMutableAttributedString(string: self.descriptionLabel1.text ?? "")
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (self.descriptionLabel1.text! as NSString).range(of: "시간 내에 교환이 완료되지 않을 경우 자동으로 취소 처리됩니다."))
        attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: (self.descriptionLabel1.text! as NSString).range(of: "시간 내에 교환이 완료되지 않을 경우 자동으로 취소 처리됩니다."))
        descriptionLabel1.attributedText = attributedStr
        
        descriptionLabel2.text = "* 교환 취소를 원하실 경우 \"북크로싱 신청 내역 조회\"에서 취소할 수 있습니다."
        
        confirmButton.setTitle("확인", for: .normal)
        
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

}
