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
    @IBOutlet weak var howToUseButtonUnderLineView: UIView!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var applyView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var applyLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var FAQButton: UIButton!
    
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK: - IBAction
    @IBAction func applyButtonTapped(_ sender: Any) {
        self.checkDeviceNetworkStatusAndShowAlert() {
            getApplicableBookList(pagesize: 21, page: 1, keyword: "") {
                let applySB = UIStoryboard(name: "Apply", bundle: nil)
                let selectBookNC = applySB.instantiateViewController(withIdentifier: "SelectBookNC")
                selectBookNC.modalPresentationStyle = .fullScreen
                self.present(selectBookNC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        self.checkDeviceNetworkStatusAndShowAlert() {
            let registerSB = UIStoryboard(name: "Apply", bundle: nil)
            let collectUserInfoNC = registerSB.instantiateViewController(withIdentifier: "CollectUserInfoNC")
            collectUserInfoNC.modalPresentationStyle = .fullScreen
            self.present(collectUserInfoNC, animated: true, completion: nil)
        }
    }
    
    @IBAction func noticeButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://www.seoulbookbogo.kr/bookcross/front/index.php?g_page=community&m_page=community01"), UIApplication.shared.canOpenURL(url) else { return }

         UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func FAQButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://www.seoulbookbogo.kr/bookcross/front/index.php?g_page=faq&m_page=faq01"), UIApplication.shared.canOpenURL(url) else { return }

         UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK: - Functions

    func setButtons() {
        
        // 그림자 설정
        setViewShadow(view: applyView, shadowRadius: 3, shadowOpacity: 0.3)
        setViewShadow(view: checkView, shadowRadius: 3, shadowOpacity: 0.3)
        setButtonShadow(button: noticeButton, shadowRadius: 3, shadowOpacity: 0.3)
        setButtonShadow(button: FAQButton, shadowRadius: 3, shadowOpacity: 0.3)
        
        // corner radius
        applyView.layer.cornerRadius = 22
        checkView.layer.cornerRadius = 22
        applyView.layer.maskedCorners = CACornerMask.layerMinXMinYCorner // 좌측 상단
        checkView.layer.maskedCorners = CACornerMask.layerMaxXMaxYCorner // 우측 하단
        noticeButton.layer.cornerRadius = 8
        FAQButton.layer.cornerRadius = 8
        
        // dynamicFont
        bookCrossingLabel.dynamicFont(fontSize: 16)
        howToUseButton.titleLabel?.dynamicFont(fontSize: 20)
        applyLabel.dynamicFont(fontSize: 20)
        checkLabel.dynamicFont(fontSize: 20)
        noticeButton.titleLabel?.dynamicFont(fontSize: 16)
        FAQButton.titleLabel?.dynamicFont(fontSize: 16)
        
        howToUseButtonUnderLineView.layer.addBorder([.bottom], color: .black, width: 2)
    }
    
    private func checkDeviceNetworkStatusAndShowAlert(completion: @escaping ()->()) {
        if(DeviceManager.shared.networkStatus) == false {
            // 네트워크 연결 X
            showAlert2(title: "서버에 연결할 수 없습니다", message: "네트워크가 연결되지 않았습니다.\nWi-Fi 또는 데이터를 활성화 해주세요.", buttonTitle1: "다시 시도", buttonTitle2: "확인", handler1: { _ in
                self.checkDeviceNetworkStatusAndShowAlert() {
                    completion()
                }
            }, handler2: nil)
        } else {
            completion()
        }
    }
}
