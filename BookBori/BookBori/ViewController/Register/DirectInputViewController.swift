//
//  DirectInputViewController.swift
//  
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit
import Photos
import AVFoundation
import Kingfisher

class DirectInputViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - variables
    var categoryTitle : String?
    var indexPath: Int = 0
    let coverImagePC = UIImagePickerController()
    var whetherUploadCoverImage: Bool = false
//    let db = Firestore.firestore()
//    let user = Auth.auth().currentUser
    var searchItem : SearchResultOfNaver.BookInfo?
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryStackView: UIStackView!
    
    @IBOutlet weak var coverImageButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var coverImageConditionLabel: UILabel!
    @IBOutlet weak var coverImageConditionLabel2: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewConditionLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var categoryTextField: UIButton!
    @IBOutlet weak var categorySelectButton: UIImageView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var categoryOpaqueView: UIView!
    @IBOutlet weak var categoryMenuStackView: UIStackView!
    
    // 카테고리 선택 버튼
    @IBOutlet weak var novelButton: UIButton!
    @IBOutlet weak var poetryEssayButton: UIButton!
    @IBOutlet weak var economicManagementButton: UIButton!
    @IBOutlet weak var selfImprovmentButton: UIButton!
    @IBOutlet weak var humanitiesButton: UIButton!
    @IBOutlet weak var historyCultureButton: UIButton!
    @IBOutlet weak var societyButton: UIButton!
    @IBOutlet weak var scienceEngineeringButton: UIButton!
    @IBOutlet weak var artPopularcultureButton: UIButton!
    @IBOutlet weak var childChildrenButton: UIButton!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        calculateDate()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        categoryOpaqueView.addGestureRecognizer(tapGesture)
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        if userSelectRegistrationMethodButton == "검색" {
            self.searchItem = dataManager.shared.searchResultOfNaver?.items[indexPath-1]
        } else if userSelectRegistrationMethodButton == "바코드" {
            self.searchItem = dataManager.shared.searchResultOfNaver?.items[indexPath]
        }
        
        applyDynamicFont()
        setElements()
        placeholderSetting()
        updateWhetherUploadCoverImage()
        
        reviewTextView.delegate = self
        coverImagePC.delegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func coverImageButtonTapped(_ sender: Any) {
        
        let uploadCoverImageAlert = UIAlertController(title: "어디서 사진을 가져올까", message: "골라줘", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.checkAlbumPermission()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.checkCameraPermission()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            self.scrollView.isScrollEnabled = true
        }
        uploadCoverImageAlert.addAction(library)
        uploadCoverImageAlert.addAction(camera)
        uploadCoverImageAlert.addAction(cancelAction)
        library.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
        camera.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
            self.present(uploadCoverImageAlert, animated: true, completion: nil)
    }
    
    // Use Photo를 눌렀을 때 or 사진을 선택했을 때
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.coverImageView.image = newImage // 받아온 이미지를 update
        whetherUploadCoverImage = true
        updateCompleteBarbuttonItemState()
        scrollView.isScrollEnabled = true
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    }
    
    // 사진 찍은 후 Retake 눌렀을 때
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 소설
    @IBAction func novelTapped(_ sender: Any) {
        comboBox(title: "소설")
        categoryTitle = "소설"
    }
    // 시/에세이
    @IBAction func poetryEssayTapped(_ sender: Any) {
        comboBox(title: "시/에세이")
        categoryTitle = "시/에세이"
    }
    // 경제/경영
    @IBAction func economicManagementTapped(_ sender: Any) {
        comboBox(title: "경제/경영")
        categoryTitle = "경제/경영"
    }
    // 자기계발
    @IBAction func selfImprovmentTapped(_ sender: Any) {
        comboBox(title: "자기계발")
        categoryTitle = "자기계발"
    }
    // 인문
    @IBAction func humanitiesTapped(_ sender: Any) {
        comboBox(title: "인문")
        categoryTitle = "인문"
    }
    // 역사/문화
    @IBAction func historyCultureTapped(_ sender: Any) {
        comboBox(title: "역사/문화")
        categoryTitle = "역사/문화"
    }
    // 사회
    @IBAction func societyTapped(_ sender: Any) {
        comboBox(title: "사회")
        categoryTitle = "사회"
    }
    // 과학/공학
    @IBAction func scienceEngineeringTapped(_ sender: Any) {
        comboBox(title: "과학/공학")
        categoryTitle = "과학/공학"
    }
    // 예술/대중문화
    @IBAction func artPopularcultureTapped(_ sender: Any) {
        comboBox(title: "예술/대중문화")
        categoryTitle = "예술/대중문화"
    }
    // 유아/어린이
    @IBAction func childChildrenTapped(_ sender: Any) {
        comboBox(title: "유아/어린이")
        categoryTitle = "유아/어린이"
    }
    
    // complete button이 활성화되는 시점
    
    @IBAction func titleTextFieldEditingChanged(_ sender: Any) {
        updateCompleteBarbuttonItemState()
    }
    @IBAction func authorTextFieldEditingChanged(_ sender: Any) {
        updateCompleteBarbuttonItemState()
    }
    @IBAction func publisherTextFieldEditingChanged(_ sender: Any) {
        updateCompleteBarbuttonItemState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCompleteBarbuttonItemState()
    }
    
    
    // 등록할 책의 데이터 입력 후 확인 버튼
    @IBAction func registrationCompleteButtonTapped(_ sender: Any) {
        
        if whetherUploadCoverImage == false {
            let inputImageAlert = UIAlertController(title: "사진 등록", message: "교환할 책의 사진을 등록해 주세요", preferredStyle: .alert)
            let inputImageAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            inputImageAlertAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")

            inputImageAlert.addAction(inputImageAlertAction)
            self.present(inputImageAlert, animated: true, completion: nil)
        }

        if  "\(reviewTextView.text!)".filter({$0 != " " && $0 != "\n"}).count < 20 {
            let shortLettersAlert = UIAlertController(title: "다시 작성해주세요", message: "다음 사람에게 전하는 말을 공백제외 20자 이상 작성해 주세요", preferredStyle: .alert)
            let shortLettersAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            shortLettersAlertAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")

            shortLettersAlert.addAction(shortLettersAlertAction)
            self.present(shortLettersAlert, animated: true, completion: nil)
            
        } else if "\(reviewTextView.text!)".filter({$0 != " " && $0 != "\n"}).count > 151 {
            let longLettersAlert = UIAlertController(title: "다시 작성해주세요", message: "다음 사람에게 전하는 말을 150자 이내로 작성해 주세요", preferredStyle: .alert)
            let longLettersAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            longLettersAlertAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")

            longLettersAlert.addAction(longLettersAlertAction)
            self.present(longLettersAlert, animated: true, completion: nil)
        }
        
        guard let completeRegisterVC = storyboard?.instantiateViewController(withIdentifier: "CompleteRegisterVC") else { return }
        self.navigationController?.pushViewController(completeRegisterVC, animated: true)
        
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.000Z"
        let convertDate = dateFormatter.date(from: searchItem!.datetime)
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let convertStr = myDateFormatter.string(from: convertDate!)
        
        let registrationCompleteAlert = UIAlertController(title: "책 등록이 완료되었습니다", message: "\(calculateDate())까지\n등록한 책을 가지고 서울책보고로 방문해 교환을 완료하세요.", preferredStyle: .alert)
        let registrationCompleteCancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let registrationCompleteConfirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            
            if let indexPath = userSelectedShelfNumber {
                guard let searchItem = self.searchItem else { return }
                self.db.collection("registrationData").document(returnDocumentName()).setData([
                    "author" : self.authorTextField.text ?? "",
                    "category" : self.categoryTitle ?? "",
                    "description" : self.reviewTextView.text ?? "",
                    "detailImage" : "",
                    "image" : searchItem.thumbnail,
                    "shelfNumber" : indexPath + 1,
                    "state" : true,
                    "title" : self.titleTextField.text ?? "",
                    "uid" : self.user?.uid ?? "",
                    "publisher" : searchItem.publisher,
                    "dateTime" : convertStr
                ]) { err in
                    if err != nil {
                        print("add registrationData: \(err)")
                    }
                }
                self.db.collection("bookShelfData").document(returnDocumentName()).setData([
                    "state" : false
                ], merge: true)
                { err in
                    if err != nil {
                        print("edit bookShelfData state: \(err)")
                    }
                }
            }
            
            var userSelectRegistrationMethodButton : String?

            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        registrationCompleteConfirmAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
        registrationCompleteCancelAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
        
        registrationCompleteAlert.addAction(registrationCompleteCancelAction)
        registrationCompleteAlert.addAction(registrationCompleteConfirmAction)
        self.present(registrationCompleteAlert, animated: true, completion: nil)
        */
    }
    
    @IBAction func categoryTextFieldTapped(_ sender: Any) {
        self.categoryOpaqueView.isHidden = false
        self.categoryMenuStackView.isHidden = false
        self.scrollView.isScrollEnabled = false
    }
    
    //MARK: - functions
    
    // 사진 앨범 접근 권한
    func checkAlbumPermission() {
        PHPhotoLibrary.requestAuthorization( { status in
            DispatchQueue.main.sync {
                switch status{
                case .authorized: print("앨범 권한 허용")
                    self.coverImagePC.sourceType = .photoLibrary
                    self.present(self.coverImagePC, animated: true, completion: nil)
                case .denied: print("앨범 권한 거부")
                    let albumPermissionAlert = UIAlertController(title: "책보리가 사진앨범에 접근하려고 합니다", message: "책보리가 사진앨범에 접근할 수 있도록 허가해 주세요", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                        guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                    albumPermissionAlert.addAction(confirmAction)
                    self.present(albumPermissionAlert, animated: true, completion: nil)
                    confirmAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
                default: break
                }
            }
        })
    }
    
    // 카메라 접근 권한
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            DispatchQueue.main.sync {
                if granted {
                    print("카메라 권한 허용")
                    self.coverImagePC.sourceType = .camera
                    self.present(self.coverImagePC, animated: true, completion: nil)
                } else {
                    print("카메라 권한 거부")
                    let cameraPermissionAlert = UIAlertController(title: "책보리가 카메라에 접근하려고 합니다", message: "책보리가 카메라에 접근할 수 있도록 허가해 주세요", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                        guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                    cameraPermissionAlert.addAction(confirmAction)
                    self.present(cameraPermissionAlert, animated: true, completion: nil)
                    confirmAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
                }
            }
        })
    }
    
    func applyDynamicFont() {
        coverImageConditionLabel.dynamicFont(fontSize: 15, weight: .light)
        coverImageConditionLabel2.dynamicFont(fontSize: 15, weight: .light)
        titleLabel.dynamicFont(fontSize: 18, weight: .bold)
        authorLabel.dynamicFont(fontSize: 18, weight: .bold)
        publisherLabel.dynamicFont(fontSize: 18, weight: .bold)
        categoryLabel.dynamicFont(fontSize: 18, weight: .bold)
        reviewLabel.dynamicFont(fontSize: 18, weight: .bold)
        reviewConditionLabel.dynamicFont(fontSize: 17, weight: .light)
        novelButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        poetryEssayButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        economicManagementButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        selfImprovmentButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        humanitiesButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        historyCultureButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        societyButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        scienceEngineeringButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        artPopularcultureButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
        childChildrenButton.titleLabel?.dynamicFont(fontSize: 15, weight: .regular)
    }

    func updateWhetherUploadCoverImage() {
        if userSelectRegistrationMethodButton == "바코드" {
            whetherUploadCoverImage = true
        } else if userSelectRegistrationMethodButton == "검색" {
            whetherUploadCoverImage = true
        } else {
            whetherUploadCoverImage = false
        }
    }
    
    private func comboBox(title: String) {
        self.categoryOpaqueView.isHidden = true
        self.categoryMenuStackView.isHidden = true
        categoryTextField.setTitleColor(.black, for: .normal)
        categoryTextField.setTitle(title, for: .normal)
        updateCompleteBarbuttonItemState()
        self.scrollView.isScrollEnabled = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.categoryOpaqueView.isHidden = true
        self.categoryMenuStackView.isHidden = true
        self.scrollView.isScrollEnabled = true
    }
    
    // 화면 빈 곳 탭하여 키보드 내리기
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func setElements() {
        completeButton.isEnabled = false
        completeButton.layer.cornerRadius = UIScreen.main.bounds.width/30
        completeButton.titleLabel?.dynamicFont(fontSize: 17, weight: .regular)
        completeButton.layer.shadowColor = UIColor.darkGray.cgColor
        completeButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        completeButton.layer.shadowRadius = 1
        completeButton.layer.shadowOpacity = 0.5
        completeButton.setTitle("완료", for: .normal)
        
        completeButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        completeButton.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        categorySelectButton.tintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        coverImageView.layer.masksToBounds = false
        coverImageView.layer.shadowRadius = 6
        coverImageView.layer.shadowOffset = .zero
        coverImageView.layer.shadowOpacity = 0.3
        coverImageView.layer.shadowColor = UIColor.black.cgColor
        
        guard let searchItem = searchItem else { return }
        
        let matchedStrData = searchItem.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "\\s?\\([^)]*\\)", with: "", options: .regularExpression)
        print("matched strData : \(matchedStrData)")
         
        
        titleTextField.text = matchedStrData
        
        /*
        if searchItem.authors.count == 1 {
            authorTextField.text = searchItem.authors[0]
        } else if searchItem.authors.count > 1 {
            authorTextField.text = "\(searchItem.authors[0]) 외 \(searchItem.authors.count-1)명"
        } */
        authorTextField.text = searchItem.author
        publisherTextField.text = searchItem.publisher.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        
        guard let imageURL = URL(string: searchItem.image) else { return }
        coverImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(
            with: imageURL,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    func placeholderSetting() {
        reviewTextView.text = "이 책을 읽고 좋았던 점 또는 책에 담긴 여러분의 이야기, 추천해주고 싶은 사람과 그 이유 등을 자유롭게 적어주세요."
        reviewTextView.textColor = UIColor.lightGray
    }
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "이 책을 읽고 좋았던 점 또는 책에 담긴 여러분의 이야기, 추천해주고 싶은 사람과 그 이유 등을 자유롭게 적어주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func updateCompleteBarbuttonItemState() {
        if titleTextField.hasText == true, authorTextField.hasText == true, publisherTextField.hasText == true,  "\(reviewTextView.text!)".filter({$0 != " " && $0 != "\n"}).count > 20 || "\(reviewTextView.text!)".filter({$0 != " " && $0 != "\n"}).count < 151, categoryTextField.titleLabel?.text != "선택", reviewTextView.text != "이 책을 읽고 좋았던 점 또는 책에 담긴 여러분의 이야기, 추천해주고 싶은 사람과 그 이유 등을 자유롭게 적어주세요." {
            completeButton.isEnabled = true
            completeButton.layer.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)
            completeButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else {
            completeButton.isEnabled = false
            completeButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            completeButton.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        }
    }
}
