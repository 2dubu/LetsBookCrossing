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
    @IBOutlet weak var descriptionBackGroundView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        
        setElements()
        dynamicFont()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isPresentedToMain() {
            self.navigationItem.hidesBackButton = false
        } else {
            self.navigationItem.hidesBackButton = true
        }
    }
    
    //MARK: - IBAction
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        if isPresentedToMain() {
            // 교환 취소
            self.showAlert1(title: "안내", message: "아직 준비 중인 기능입니다.", buttonTitle: "확인", handler: nil)
        } else {
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    //MARK: - Functions
    func isPresentedToMain() -> Bool {
        let nv = (presentingViewController?.presentedViewController as? UINavigationController)
        let viewControllersCount = nv?.viewControllers.count
        if viewControllersCount != nil && viewControllersCount! <= 3 {
            // 메인 화면에서 띄워짐 -> 사용자가 신청 내역 조회 중
            return true
        } else {
            // 메인 화면에서 띄워지지 않음 -> 사용자가 도서 교환 중
            return false
        }
    }
    
    func setElements() {
        
        // comfirmButton 세팅
        confirmButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        setButtonShadow(button: confirmButton, shadowRadius: 1, shadowOpacity: 0.5)
        setImageShadow(image: self.applyImageView, shadowRadius: 3, shadowOpacity: 0.2)
        setImageShadow(image: self.registerImageView, shadowRadius: 3, shadowOpacity: 0.2)
        descriptionBackGroundView.layer.cornerRadius = 10
        setViewShadow(view: descriptionBackGroundView, shadowRadius: 3, shadowOpacity: 0.4)
        
        if isPresentedToMain() {
            navigationItem.title = "신청내역 조회"
            
            description1.text = "(신청일)에 신청하셨습니다.\n익일(내일 / 서울책보고 업무시간 이내) 이내에 \"서울책보고\"에 방문하셔서\n교환을 완료하여 주시기 바랍니다."
            description2.text = "서울책보고 업무시간은 평일 11시 ~ 20시, 주말 및 공휴일 10시 ~ 20시입니다.\n* 매주 월요일, 1월1일, 설날 및 추석연휴는 휴관일입니다."
            
            // image, bookTitle set
            
            confirmButton.setTitle("북크로싱 신청 취소", for: .normal)
        } else {
            navigationItem.title = "북크로싱 정보 확인"
            description1.text = "신청이 완료되었습니다.\n익일(내일 / 서울책보고 업무시간 이내) 이내에 \"서울책보고\"에 방문하셔서\n교환을 완료하여 주시기 바랍니다."
            description2.text = "교환 신청 취소는\"북크로싱 신청 내역 조회\"\n에서 진행할 수 있습니다."
            
            registerImageView.image = UIImage(named: bookApplied?.image ?? "")
            //applyImageView.image = UIImage(named: bookRegister?.image ?? "")
            applyImageView.image = UIImage(named: "1")
            
            registerTitleLabel.text = bookApplied?.title
            applyTitleLabel.text = bookRegister?.title
            
            confirmButton.setTitle("확인", for: .normal)
        }
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
        
        confirmButton.titleLabel?.dynamicFont(fontSize: 18)
    }

}
