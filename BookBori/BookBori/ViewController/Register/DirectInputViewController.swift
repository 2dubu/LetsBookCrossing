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
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var coverImageButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var pubdateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var pubdateTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        scrollView.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        backgroundView.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        whiteView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        whiteView.layer.cornerRadius = 15
        whiteView.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView.layer.borderWidth = 0.5
        whiteView.layer.shadowRadius = 3
        whiteView.layer.shadowOffset = .zero
        whiteView.layer.shadowOpacity = 0.3
        whiteView.layer.shadowColor = UIColor.gray.cgColor
        
        if userSelectRegistrationMethodButton == "검색" {
            self.searchItem = dataManager.shared.searchResultOfNaver?.items[indexPath-1]
        } else if userSelectRegistrationMethodButton == "바코드" {
            self.searchItem = dataManager.shared.searchResultOfNaver?.items[indexPath]
        }
        
        applyDynamicFont()
        setElements()
        updateWhetherUploadCoverImage()
        updateCompleteBarbuttonItemState()
        
        reviewTextView.delegate = self
        coverImagePC.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
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
        library.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
        camera.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
            self.present(uploadCoverImageAlert, animated: true, completion: nil)
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
    @IBAction func pubDateTextFieldEditingChanged(_ sender: Any) {
        updateCompleteBarbuttonItemState()
    }
    
    
    // 등록할 책의 데이터 입력 후 확인 버튼
    @IBAction func registrationCompleteButtonTapped(_ sender: Any) {
        
        if whetherUploadCoverImage == false {
            let inputImageAlert = UIAlertController(title: "사진 등록", message: "교환할 책의 사진을 등록해 주세요", preferredStyle: .alert)
            let inputImageAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            inputImageAlertAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")

            inputImageAlert.addAction(inputImageAlertAction)
            self.present(inputImageAlert, animated: true, completion: nil)
        }
        
        bookRegister = Book(title: titleTextField.text ?? "", image: "", author: authorTextField.text ?? "", publisher: publisherTextField.text ?? "", yearPublished: Int(pubdateTextField.text ?? "0") ?? 0)
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
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
            
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
                    confirmAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
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
                    confirmAction.setValue(UIColor(#colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)), forKey: "titleTextColor")
                }
            }
        })
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
    
    func applyDynamicFont() {
        titleLabel.dynamicFont(fontSize: 18)
        authorLabel.dynamicFont(fontSize: 18)
        publisherLabel.dynamicFont(fontSize: 18)
        pubdateLabel.dynamicFont(fontSize: 18)
        reviewLabel.dynamicFont(fontSize: 18)
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
    
    func setElements() {
        
        // 텍스트필트 글씨체 설정
        titleTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        authorTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        publisherTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        pubdateTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        reviewTextView.font = UIFont(name: "GmarketSansLight", size: 14)
        
        // 텍스트필드 leftPadding
        titleTextField.addLeftPadding()
        authorTextField.addLeftPadding()
        publisherTextField.addLeftPadding()
        pubdateTextField.addLeftPadding()
        
        //completeButton.isEnabled = false
        completeButton.layer.cornerRadius = UIScreen.main.bounds.width/30
        completeButton.titleLabel?.dynamicFont(fontSize: 17)
        completeButton.layer.shadowColor = UIColor.darkGray.cgColor
        completeButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        completeButton.layer.shadowRadius = 1
        completeButton.layer.shadowOpacity = 0.5
        
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        coverImageView.layer.masksToBounds = false
        coverImageView.layer.shadowOffset = .zero
        coverImageView.layer.shadowOpacity = 0.3
        coverImageView.layer.shadowColor = UIColor.gray.cgColor
        
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
        authorTextField.text = searchItem.author.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        publisherTextField.text = searchItem.publisher.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        
        var pubdate = searchItem.pubdate
        //pubdate.removeLast(2)
        //pubdate.insert(contentsOf: "년 ", at: pubdate.index(pubdate.startIndex, offsetBy: 4))
        //pubdate.append(contentsOf: "월")
        pubdateTextField.text = pubdate
        
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
    
    func updateCompleteBarbuttonItemState() {
        
        if titleTextField.hasText == true, authorTextField.hasText == true, publisherTextField.hasText == true, pubdateTextField.hasText == true {
            
            let regex = try? NSRegularExpression(pattern: "[0-9]{8}")
            if let _ = regex?.firstMatch(in: pubdateTextField.text!, options: [], range: NSRange(location: 0, length: pubdateTextField.text!.count)) {
                print("됐어???")
                completeButton.isEnabled = true
                completeButton.layer.backgroundColor = #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)
                completeButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            } else {
                print("안됐나...")
                completeButton.isEnabled = false
                completeButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                completeButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            }
        }
    }
    
}
