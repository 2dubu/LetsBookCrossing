//
//  MainViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit
import Lottie

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
    
    // present loading views
    @IBOutlet weak var opaqueView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK: - IBAction
    @IBAction func applyButtonTapped(_ sender: Any) {
        self.startAnimation()
        
        getApplicableBookList(pagesize: 21, page: 1, keyword: "") { [weak self] in
            guard let self = self else { return }
            let applySB = UIStoryboard(name: "Apply", bundle: nil)
            let selectBookNC = applySB.instantiateViewController(withIdentifier: "SelectBookNC")
            selectBookNC.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(selectBookNC, animated: true) {
                    self.stopAnimation()
                }
            }
        } error: {
            self.showServerErrorAlert()
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        let registerSB = UIStoryboard(name: "Apply", bundle: nil)
        let collectUserInfoNC = registerSB.instantiateViewController(withIdentifier: "CollectUserInfoNC")
        collectUserInfoNC.modalPresentationStyle = .fullScreen
        self.present(collectUserInfoNC, animated: true, completion: nil)
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

    /// init views
    private func initView() {
        setShadows()
        setLayers()
        setFonts()
        setAnimationView()
    }
    
    /// 그림자 설정
    private func setShadows() {
        setViewShadow(view: applyView, shadowRadius: 3, shadowOpacity: 0.3)
        setViewShadow(view: checkView, shadowRadius: 3, shadowOpacity: 0.3)
        setButtonShadow(button: noticeButton, shadowRadius: 3, shadowOpacity: 0.3)
        setButtonShadow(button: FAQButton, shadowRadius: 3, shadowOpacity: 0.3)
    }
    
    /// layer 스타일 적용
    private func setLayers() {
        applyView.layer.cornerRadius = 22
        checkView.layer.cornerRadius = 22
        applyView.layer.maskedCorners = CACornerMask.layerMinXMinYCorner // 좌측 상단
        checkView.layer.maskedCorners = CACornerMask.layerMaxXMaxYCorner // 우측 하단
        noticeButton.layer.cornerRadius = 8
        FAQButton.layer.cornerRadius = 8
        
        howToUseButtonUnderLineView.layer.addBorder([.bottom], color: .black, width: 2)
    }
    
    /// 폰트 적용
    private func setFonts() {
        bookCrossingLabel.dynamicFont(fontSize: 16)
        howToUseButton.titleLabel?.dynamicFont(fontSize: 20)
        applyLabel.dynamicFont(fontSize: 20)
        checkLabel.dynamicFont(fontSize: 20)
        noticeButton.titleLabel?.dynamicFont(fontSize: 16)
        FAQButton.titleLabel?.dynamicFont(fontSize: 16)
    }
    
    /// 화면 전환 로딩 애니메이션 뷰 세팅
    private func setAnimationView() {
        opaqueView.isHidden = true
        animationView.isHidden = true
        
        animationView.animationSpeed = 2.0
        animationView.loopMode = .loop
    }
    
    private func startAnimation() {
        opaqueView.isHidden = false
        animationView.isHidden = false
        
        animationView.play()
    }
    
    private func stopAnimation() {
        opaqueView.isHidden = true
        animationView.isHidden = true
        
        animationView.stop()
    }
}
