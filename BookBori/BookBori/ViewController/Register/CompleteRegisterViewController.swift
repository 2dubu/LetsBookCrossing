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
        
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK: - IBAction
    @IBAction func confirmButtonTapped(_ sender: Any) {
        // 신청 프로세스 이후 ExchangeDataManager 초기화
        ExchangeDataManager.shared.resetData()
        self.dismiss(animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Functions
    
    func setElements() {
        
        // comfirmButton 세팅
        confirmButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        setButtonShadow(button: confirmButton, shadowRadius: 1, shadowOpacity: 0.5)
        setImageShadow(image: self.applyImageView, shadowRadius: 3, shadowOpacity: 0.2)
        setImageShadow(image: self.registerImageView, shadowRadius: 3, shadowOpacity: 0.2)
        descriptionBackGroundView.layer.cornerRadius = 10
        setViewShadow(view: descriptionBackGroundView, shadowRadius: 3, shadowOpacity: 0.4)
        
        navigationItem.title = "북크로싱 정보 확인"
        description1.text = "신청이 완료되었습니다.\n익일(내일 / 서울책보고 업무시간 이내) 이내에 \"서울책보고\"에 방문하셔서\n교환을 완료하여 주시기 바랍니다."
        description2.text = "교환 신청 취소는\"북크로싱 신청 내역 조회\"\n에서 진행할 수 있습니다."
        
        guard let registerBookImageData = ExchangeDataManager.shared.bookRegister?.imageData else { return }
        registerImageView.image = UIImage(data: registerBookImageData)
        
        applyImageView.kf.indicatorType = .activity
        applyImageView.kf.setImage(
            with: URL(string: ExchangeDataManager.shared.applyBookInfo?.imageURL ?? ""),
            placeholder: UIImage(named: "imageNotFound"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.7)),
                .cacheOriginalImage
            ])
        
        registerTitleLabel.text = ExchangeDataManager.shared.bookRegister?.title
        applyTitleLabel.text = ExchangeDataManager.shared.applyBookInfo?.title
        
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
