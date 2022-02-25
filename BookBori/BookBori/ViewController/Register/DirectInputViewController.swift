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
    @IBOutlet weak var pubdateStackView: UIStackView!
    
    @IBOutlet weak var coverImageButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var coverImageConditionLabel: UILabel!
    @IBOutlet weak var coverImageConditionLabel2: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var pubdateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewConditionLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var pubdateTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        calculateDate()
        
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
        pubdateLabel.dynamicFont(fontSize: 18, weight: .bold)
        reviewLabel.dynamicFont(fontSize: 18, weight: .bold)
        reviewConditionLabel.dynamicFont(fontSize: 17, weight: .light)
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
        
        coverImageView.layer.masksToBounds = false
        coverImageView.layer.shadowRadius = 6
        coverImageView.layer.shadowOffset = .zero
        coverImageView.layer.shadowOpacity = 0.3
        coverImageView.layer.shadowColor = UIColor.black.cgColor
        
        guard let searchItem = searchItem else { return }
        
        let matchedStrData = searchItem.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "\\s?\\([^)]*\\)", with: "", options: .regularExpression)
        print("matched strData : \(matchedStrData)")
        
        // YYYYMMDD -> YYYY년 M월로 수정 필요
        
        titleTextField.text = matchedStrData
        
        /*
        if searchItem.authors.count == 1 {
            authorTextField.text = searchItem.authors[0]
        } else if searchItem.authors.count > 1 {
            authorTextField.text = "\(searchItem.authors[0]) 외 \(searchItem.authors.count-1)명"
        } */
        authorTextField.text = searchItem.author.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        publisherTextField.text = searchItem.publisher.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        pubdateTextField.text = searchItem.pubdate
        
        guard let imageURL = URL(string: searchItem.image) else { return }
        coverImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "beforeRegistrationImage"),
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
        if titleTextField.hasText == true, authorTextField.hasText == true, publisherTextField.hasText == true, pubdateTextField.hasText == true, "\(reviewTextView.text!)".filter({$0 != " " && $0 != "\n"}).count > 20 || "\(reviewTextView.text!)".filter({$0 != " " && $0 != "\n"}).count < 151, reviewTextView.text != "이 책을 읽고 좋았던 점 또는 책에 담긴 여러분의 이야기, 추천해주고 싶은 사람과 그 이유 등을 자유롭게 적어주세요." {
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
