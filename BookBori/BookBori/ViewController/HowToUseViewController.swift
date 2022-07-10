//
//  HowToUserViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/03/29.
//

import UIKit
import Gifu

class HowToUserViewController: UIViewController {
    
    // MARK: - Variables
    var nowPage: Int = 0
    
    // MARK: - IBOutlets
    @IBOutlet weak var whiteView1: UIView!
    @IBOutlet weak var howToUseImageView: UIImageView!
    @IBOutlet weak var bookcrossingLabel: UILabel!
    @IBOutlet weak var bookcrossingDescriptionLabel: UILabel!
    @IBOutlet weak var seoulBookbogoLabel: UILabel!
    @IBOutlet weak var seoulBookbogoDescriptionLabel: UILabel!
    
    @IBOutlet weak var wayToParticipateTitleLabel: UILabel!
    
    @IBOutlet weak var wayToParticipateCollectionView: UICollectionView!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var whiteView2: UIView!
    @IBOutlet weak var afterApplyLabel: UILabel!
    @IBOutlet weak var afterApplyDescriptionLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wayToParticipateCollectionView.delegate = self
        wayToParticipateCollectionView.dataSource = self
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        initView()
    }
    
    /// init views
    private func initView() {
        setNavigation()
        setWhiteView()
        dynamicFont()
        applyAttribute()
    }
    
    /// navigatoin 설정
    private func setNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!
        ]
    }
    
    /// 흰 배경 뷰 설정
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
    
    /// 폰트 설정
    func dynamicFont() {
        bookcrossingLabel.dynamicFont(fontSize: 20)
        bookcrossingDescriptionLabel.dynamicFont(fontSize: 16)
        seoulBookbogoLabel.dynamicFont(fontSize: 20)
        seoulBookbogoDescriptionLabel.dynamicFont(fontSize: 16)
        
        wayToParticipateTitleLabel.dynamicFont(fontSize: 22)
        afterApplyLabel.dynamicFont(fontSize: 22)
        afterApplyDescriptionLabel.dynamicFont(fontSize: 16)
    }
    
    /// Attribute 적용
    func applyAttribute() {
        guard let text = self.afterApplyDescriptionLabel.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        
        // 특정 문자 굵기 변경
        guard let font = UIFont(name: "GmarketSansMedium", size: 16) else { return }
        attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: "신청 당일 또는 다음 날 운영 시간 이내"))
        attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: "안내 데스크에 문의"))
        
        // 행간 간격 조절
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
        
        afterApplyDescriptionLabel.attributedText = attributeString
        afterApplyDescriptionLabel.textAlignment = .center
    }
}

// MARK: - CollectionViewDelegate
extension HowToUserViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HowToUseDummyData.shared.descriptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wayToParticipateCollectionView.dequeueReusableCell(withReuseIdentifier: "WayToParticipateCell", for: indexPath) as! WayToParticipateCollectionViewCell
        cell.descriptionLabel.text = HowToUseDummyData.shared.descriptions[indexPath.row].description
        cell.gifImageView.animate(withGIFNamed: HowToUseDummyData.shared.descriptions[indexPath.row].image)
        
        // Set whiteView
        cell.whiteView.layer.cornerRadius = 15
        cell.whiteView.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cell.whiteView.layer.borderWidth = 0.5
        setViewShadow(view: cell.whiteView, shadowRadius: 3, shadowOpacity: 0.3)
        
        // Set descriptionLabel
        let text = cell.descriptionLabel.text
        let attributeString = NSMutableAttributedString(string: text ?? "")
        // 특정 문자 색상 변경
        attributeString.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1) , range: (text! as NSString).range(of:"첫 번째,"))
        attributeString.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1), range: (text! as NSString).range(of:"두 번째,"))
        attributeString.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1), range: (text! as NSString).range(of:"세 번째,"))
        
        // 특정 문자 굵기 변경
        attributeString.addAttribute(.font, value: UIFont(name: "GmarketSansMedium", size: 16)!, range: (text! as NSString).range(of: "첫 번째,"))
        attributeString.addAttribute(.font, value: UIFont(name: "GmarketSansMedium", size: 16)!, range: (text! as NSString).range(of: "두 번째,"))
        attributeString.addAttribute(.font, value: UIFont(name: "GmarketSansMedium", size: 16)!, range: (text! as NSString).range(of: "세 번째,"))
        attributeString.addAttribute(.font, value: UIFont(name: "GmarketSansMedium", size: 16)!, range: (text! as NSString).range(of: "교환하고 싶은 도서 선택"))
        attributeString.addAttribute(.font, value: UIFont(name: "GmarketSansMedium", size: 16)!, range: (text! as NSString).range(of: "전화번호와 비밀번호 입력"))
        attributeString.addAttribute(.font, value: UIFont(name: "GmarketSansMedium", size: 16)!, range: (text! as NSString).range(of: "선택한 책과 교환할,\n자신의 책 등록"))
        cell.descriptionLabel.attributedText = attributeString
        
        // 행간 간격 조절
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
        cell.descriptionLabel.attributedText = attributeString
        
        // 중간 정렬
        cell.descriptionLabel.textAlignment = .center
        
        return cell
    }
    
    /// 컬렉션뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: wayToParticipateCollectionView.frame.size.width, height:  wayToParticipateCollectionView.frame.height)
    }
    
    /// 컬렉션뷰 감속 끝났을 때 현재 페이지 체크
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = nowPage
    }
}


