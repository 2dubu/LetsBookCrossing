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
        
        self.view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        
        dynamicFont()
        setButton()
        setTextField()
        updateContinueButton()
        
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
        
        let nv = (presentingViewController?.presentedViewController as? UINavigationController)
        let viewControllersCount = nv?.viewControllers.count
        if viewControllersCount != nil && viewControllersCount! < 3 {
            self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "xmark")
            self.navigationItem.title = "사용자 정보 확인"
            self.descriptionLabel.text = "교환을 신청하는 과정에서 입력했던 전화번호와 비밀번호를 입력해 신청내역 조회 또는 신청 취소를 진행할 수 있습니다."
        } else {
            self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "chevron.backward")
            self.navigationItem.title = "사용자 정보 입력"
            self.descriptionLabel.text = "이곳에서 입력하시는 정보는 이후 교환 시에 또는 신청내역 조회 및 신청 취소 전, 사용자를 확인하는 목적으로 사용됩니다."
        }
    }
    
    
    // MARK: - IBOutlet & IBAction
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let nv = (presentingViewController?.presentedViewController as? UINavigationController)
        let viewControllersCount = nv?.viewControllers.count
        if viewControllersCount != nil && viewControllersCount! < 3 {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        let nv = (presentingViewController?.presentedViewController as? UINavigationController)
        let viewControllersCount = nv?.viewControllers.count
        if viewControllersCount != nil && viewControllersCount! < 3 {
            // 신청내역 조회 화면에서 이 화면을 띄웠을 때
            checkToPush()
            let registerSB = UIStoryboard(name: "Register", bundle: nil)
            let checkVC = registerSB.instantiateViewController(withIdentifier: "CheckVC")
            self.navigationController?.pushViewController(checkVC, animated: true)
        } else {
            // 도서 신청 중 이 화면을 띄웠을 때
            checkToPush()
            getIsApplicableUser(phoneNum: self.phoneNumberTextField.text!) {
                if SeoulBookBogoDataManager.shared.isApplicableUser?.data.canApply == true {
                    let registerSB = UIStoryboard(name: "Register", bundle: nil)
                    let setRegistrationVC = registerSB.instantiateViewController(withIdentifier: "SetRegistrationVC")
                    self.navigationController?.pushViewController(setRegistrationVC, animated: true)
                } else {
                    self.showAlert1(title: "신청 불가", message: "동시에 5권 까지만 신청 가능합니다.\n신청 취소 또는 교환 완료 후 다시 신청하세요", buttonTitle: "확인", handler: nil)
                }
            } error: {
                self.showServerErrorAlert()
            }

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
        phoneNumberLabel.dynamicFont(fontSize: 20)
        passwordLabel.dynamicFont(fontSize: 20)
        descriptionLabel.dynamicFont(fontSize: 15)
        continueButton.titleLabel?.dynamicFont(fontSize: 18)
    }
    
    func setButton() {
        continueButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        continueButton.layer.shadowColor = UIColor.darkGray.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        continueButton.layer.shadowRadius = 1
        continueButton.layer.shadowOpacity = 0.5
    }
    
    func setTextField() {
        phoneNumberTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        passwordTextField.font = UIFont(name: "GmarketSansLight", size: 14)
        phoneNumberTextField.keyboardType = .numberPad
        passwordTextField.keyboardType = .numberPad
        
        phoneNumberTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
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
            self.showAlert1(title: "안내", message: "전화번호 형식이 올바르지 않아요\n다시 한 번 확인해주세요", buttonTitle: "확인", handler: nil)
        } else {
            self.showAlert1(title: "안내", message: "비밀번호 형식이 올바르지 않아요\n다시 한 번 확인해 주세요", buttonTitle: "확인", handler: nil)
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
}
