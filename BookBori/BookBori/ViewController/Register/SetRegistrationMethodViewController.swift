//
//  SetRegistrationMethodViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit
import AVFoundation

class SetRegistrationMethodViewController: UIViewController {
    
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
        //userSelectRegistrationMethodButton = "바코드"
    }
    /*
    @IBAction func searchTitleButtonTapped(_ sender: Any) {
        userSelectRegistrationMethodButton = "검색"
    }
    @IBAction func directButtonTapped(_ sender: Any) {
        userSelectRegistrationMethodButton = "입력"
    }
     */

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "내 책 등록하기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 20)!]
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)
        
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
                      let cameraPermissionAlert = UIAlertController(title: "책보리가 카메라에 접근하려고 합니다", message: "바코드 스캔을 위해 카메라 접근 권한을 허가해 주세요", preferredStyle: .alert)
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

