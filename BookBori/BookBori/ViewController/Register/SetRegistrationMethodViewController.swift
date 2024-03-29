//
//  SetRegistrationMethodViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit
import AVFoundation

class SetRegistrationMethodViewController: UIViewController {
    
    let exchangeDM = ExchangeDataManager.shared
    
    //MARK: - IBOutlet & IBAction
    
    @IBOutlet weak var chooseMethodLabel: UILabel!
    @IBOutlet weak var barcodeButton: UIButton!
    @IBOutlet weak var searchTitleButton: UIButton!
    @IBOutlet weak var directButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func barcodeButtonTapped(_ sender: Any) {
        checkCameraPermission()
        exchangeDM.registrationMethod = .scanBarcode
        self.checkApplicable(bookPK: exchangeDM.applyBookInfo?.bookPK ?? "0") {
            guard let scanBarcodeVC = self.storyboard?.instantiateViewController(identifier: "ScanBarcodeVC") as? ScanBarcodeViewController else { return }
            self.navigationController?.pushViewController(scanBarcodeVC, animated: true)
        }
    }
    @IBAction func searchTitleButtonTapped(_ sender: Any) {
        exchangeDM.registrationMethod = .seach
        
        self.checkApplicable(bookPK: exchangeDM.applyBookInfo?.bookPK ?? "0") {
            guard let searchBookVC = self.storyboard?.instantiateViewController(identifier: "SearchBookVC") as? SearchBookViewController else { return }
            self.navigationController?.pushViewController(searchBookVC, animated: true)
        }
    }
    @IBAction func directButtonTapped(_ sender: Any) {
        exchangeDM.registrationMethod = .DirectInput
        self.checkApplicable(bookPK: exchangeDM.applyBookInfo?.bookPK ?? "0") {
            guard let directInputVC = self.storyboard?.instantiateViewController(identifier: "DirectInputVC") as? DirectInputViewController else { return }
            self.navigationController?.pushViewController(directInputVC, animated: true)
        }
    }

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "내 책 등록하기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)
        
        chooseMethodLabel.text = "도서를 등록할 방법을\n선택하세요."
        
        applyDynamicFont()
        setButton()
        view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
    }
    
    //MARK: - functions
    
    // 카메라 접근 권한
      func checkCameraPermission() {
          AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
              DispatchQueue.main.sync {
                  if granted {
                      print("카메라 권한 허용")
                  } else {
                      print("카메라 권한 거부")
                      self.showAlert1(title: "책보리가 카메라에 접근하려고 합니다", message: "바코드 스캔을 위해 카메라 접근 권한을 허가해 주세요", buttonTitle: "확인") { _ in
                          guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
                          UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                      }
                  }
              }
          })
      }
    
    func applyDynamicFont() {
        chooseMethodLabel.dynamicFont(fontSize: 20)
        barcodeButton.titleLabel?.dynamicFont(fontSize: 18)
        searchTitleButton.titleLabel?.dynamicFont(fontSize: 18)
        directButton.titleLabel?.dynamicFont(fontSize: 18)
    }
    
    func setButton() {
        barcodeButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        searchTitleButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        directButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        
        barcodeButton.layer.shadowColor = UIColor.darkGray.cgColor
        barcodeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        barcodeButton.layer.shadowRadius = 5
        barcodeButton.layer.shadowOpacity = 0.3
        
        searchTitleButton.layer.shadowColor = UIColor.darkGray.cgColor
        searchTitleButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchTitleButton.layer.shadowRadius = 5
        searchTitleButton.layer.shadowOpacity = 0.3
        
        directButton.layer.shadowColor = UIColor.darkGray.cgColor
        directButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        directButton.layer.shadowRadius = 5
        directButton.layer.shadowOpacity = 0.3
    }
}

