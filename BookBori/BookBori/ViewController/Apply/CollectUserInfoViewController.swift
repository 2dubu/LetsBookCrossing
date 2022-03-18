//
//  CollectUserInfoViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/23.
//

import UIKit

class CollectUserInfoViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - viewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.9921568627, blue: 0.862745098, alpha: 1)
        
        dynamicFont()
        setButton()
        setTextField()
        updateContinueButton()
        
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    // MARK: - IBOutlet & IBAction
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        // 바로 전 뷰를 확인하는 부분에 문제가 있음
        let nv = self.presentedViewController
//        let nv = self.navigationController as? UINavigationController
//        let sv = nv?.viewControllers.last
        if nv != nil && nv!.isKind(of: MainViewController.self) {
            // 신청내역 조회 화면에서 이 화면을 띄웠을 때
            checkToPush()
            let registerSB = UIStoryboard(name: "Check", bundle: nil)
            let checkVC = registerSB.instantiateViewController(withIdentifier: "CheckVC")
            self.navigationController?.pushViewController(checkVC, animated: true)
        } else {
            // 도서 신청 중 이 화면을 띄웠을 때
            checkToPush()
            let registerSB = UIStoryboard(name: "Register", bundle: nil)
            let setRegistrationVC = registerSB.instantiateViewController(withIdentifier: "SetRegistrationVC")
            self.navigationController?.pushViewController(setRegistrationVC, animated: true)
        }
    }
    
    @IBAction func phoneNumberTextFieldEditingChanged(_ sender: Any) {
        updateContinueButton()
        
        if let text = phoneNumberTextField.text {
            let maxLength = 11
            if text.count == maxLength {
                phoneNumberTextField.resignFirstResponder()
            }
            if text.count > maxLength {
                let index = text.index(text.startIndex, offsetBy: maxLength)
                let newString = text[text.startIndex..<index]
                phoneNumberTextField.text = String(newString)
            }
        }
    }
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: Any) {
        updateContinueButton()
        
        if let text = passwordTextField.text {
            let maxLength = 4
            if text.count == maxLength {
                passwordTextField.resignFirstResponder()
            }
            if text.count > maxLength {
                let index = text.index(text.startIndex, offsetBy: maxLength)
                let newString = text[text.startIndex..<index]
                passwordTextField.text = String(newString)
            }
        }
    }
    
    // MARK: - function
    
    func dynamicFont() {
        phoneNumberLabel.dynamicFont(fontSize: 17)
        passwordLabel.dynamicFont(fontSize: 17)
        continueButton.titleLabel?.dynamicFont(fontSize: 10)
    }
    
    func setButton() {
        continueButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        continueButton.layer.shadowColor = UIColor.darkGray.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        continueButton.layer.shadowRadius = 1
        continueButton.layer.shadowOpacity = 0.5
        continueButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        continueButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    func setTextField() {
        
        phoneNumberTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        passwordTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        phoneNumberTextField.keyboardType = .numberPad
        passwordTextField.keyboardType = .numberPad
        
        phoneNumberTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
    }
    
    // presentingVC에 따라 설명글을 다르게 설정
    func setDescriptions() {
        let nv = (presentingViewController as? UINavigationController)
        let sv = nv?.viewControllers.last
        if sv != nil && sv!.isKind(of: MainViewController.self) {
            // 신청내역 조회 화면에서 이 화면을 띄웠을 때
            
        } else {
            // 도서 신청 중 이 화면을 띄웠을 때
        }
    }
    
    func checkToPush() {
        var phoneNumberSuitable : Bool = false
        var passwordSuitable : Bool = false
        
        // 전화번호 검사
        let phoneNumberRegex = try? NSRegularExpression(pattern: "^01([0-9])([0-9]{3,4})([0-9]{4})$")
        guard let phoneNumberText = phoneNumberTextField.text else { return }
        if ((phoneNumberRegex?.firstMatch(in: phoneNumberText, options: [], range: NSRange(location: 0, length: phoneNumberText.count))) != nil) {
            phoneNumberSuitable = true
        }
        
        // 비밀번호 검사
        let passwordRegex = try? NSRegularExpression(pattern: "^[0-9]{4,4}$")
        guard let passwordText = passwordTextField.text else { return }
        if ((passwordRegex?.firstMatch(in: passwordText, options: [], range: NSRange(location: 0, length: passwordText.count))) != nil) {
            passwordSuitable = true
        }
        
        if phoneNumberSuitable == true && passwordSuitable == true {
            userPhoneNumber = phoneNumberText
            userPassword = passwordText
        } else if phoneNumberSuitable == false {
            self.present(UtilitiesForAlert.returnAlert(title: "안내", msg: "전화번호 형식이 올바르지 않아요\n다시 한 번 확인해주세요", buttonTitle: "확인", handler: nil), animated: true, completion: nil)
        } else {
            self.present(UtilitiesForAlert.returnAlert(title: "안내", msg: "비밀번호 형식이 올바르지 않아요\n다시 한 번 확인해 주세요", buttonTitle: "확인", handler: nil), animated: true, completion: nil)
        }
    }
    
    func updateContinueButton() {
        if phoneNumberTextField.hasText && passwordTextField.hasText {
            continueButton.isEnabled = true
            continueButton.setTitleColor(.white, for: .normal)
            continueButton.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.6156862745, blue: 0.3764705882, alpha: 1)
            
        } else {
            continueButton.isEnabled = false
            continueButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            continueButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
