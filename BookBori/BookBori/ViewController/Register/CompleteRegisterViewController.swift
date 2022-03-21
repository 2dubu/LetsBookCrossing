//
//  CompleteRegisterViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/23.
//

import UIKit

class CompleteRegisterViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var applyLabel: UILabel!
    
    @IBOutlet weak var registerImageView: UIImageView!
    @IBOutlet weak var applyImageView: UIImageView!
    @IBOutlet weak var registerTitleLabel: UILabel!
    @IBOutlet weak var applyTitleLabel: UILabel!
    
    @IBOutlet weak var exchangeIcon: UIImageView!
    
    @IBOutlet weak var description1: UILabel!
    @IBOutlet weak var description2: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        
        setElements()
        dynamicFont()
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
                
        navigationItem.title = "도서 교환 정보"
        
        registerImageView.image = UIImage(named: bookApplied?.image ?? "")
        //applyImageView.image = UIImage(named: bookRegister?.image ?? "")
        applyImageView.image = UIImage(named: "1")
        
        registerTitleLabel.text = bookApplied?.title
        applyTitleLabel.text = bookRegister?.title
        
        description1.text = "신청이 완료되었습니다.\n익일(내일 / 서울책보고 업무시간 이내) 이내에 \"서울책보고\"에 방문하셔서\n교환을 완료하여 주시기 바랍니다."
        description2.text = "\"북크로싱 신청 내역 조회\"에서\n교환을 취소할 수 있습니다."
        
        // comfirmButton 세팅
        confirmButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        setButtonShadow(button: confirmButton, shadowRadius: 1, shadowOpacity: 0.5)
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
    
    func dynamicFont() {
        registerLabel.dynamicFont(fontSize: 19)
        applyLabel.dynamicFont(fontSize: 19)
        registerTitleLabel.dynamicFont(fontSize: 15)
        applyTitleLabel.dynamicFont(fontSize: 15)
        
        description1.dynamicFont(fontSize: 15)
        description2.dynamicFont(fontSize: 15)
        
        confirmButton.titleLabel?.dynamicFont(fontSize: 20)
    }

}
