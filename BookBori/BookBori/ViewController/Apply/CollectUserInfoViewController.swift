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
        
        dynamicFont()
        setButton()
        updateContinueButton()
        
        phoneNumberTextField.keyboardType = .numberPad
        passwordTextField.keyboardType = .numberPad
        
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    // MARK: - IBOutlet & IBAction
    
    @IBOutlet weak var collectUserInfoTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if phoneNumberTextField.hasText && passwordTextField.hasText {
            
            var phoneNumberSuitable : Bool = false
            var passwordSuitable : Bool = false
        
            // 전화번호 검사
            let phoneNumberRegex = try? NSRegularExpression(pattern: "^01([0-9])-([0-9]{3,4})-([0-9]{4})$")
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
                self.present(UtilitiesForAlert.returnAlert(title: "안내", msg: "비밀번호를 다시 한 번 확인해 주세요", buttonTitle: "확인", handler: nil), animated: true, completion: nil)
            }
            
        }
    }
    
    var pastCount : Int?
    @IBAction func phoneNumberTextFieldEditingChanged(_ sender: Any) {
        updateContinueButton()
        
        guard let text = phoneNumberTextField.text else { return }
        
        if phoneNumberTextField.text?.count ?? 0 > pastCount ?? 0 {
            let maxLength = 13
            if text.count == maxLength {
                phoneNumberTextField.resignFirstResponder()
            }
            if text.count == 3 {
                phoneNumberTextField.text! += "-"
            } else if text.count == 8 {
                phoneNumberTextField.text! += "-"
            } else if text.count > maxLength {
                let index = text.index(text.startIndex, offsetBy: maxLength)
                let newString = text[text.startIndex..<index]
                phoneNumberTextField.text = String(newString)
            }
        } else {
            if phoneNumberTextField.text?.hasSuffix("-") == true {
                phoneNumberTextField.text?.removeLast(1)
            }
        }
        pastCount = phoneNumberTextField.text?.count
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
        collectUserInfoTitleLabel.dynamicFont(fontSize: 26)
        phoneNumberLabel.dynamicFont(fontSize: 17)
        passwordLabel.dynamicFont(fontSize: 17)
        continueButton.titleLabel?.dynamicFont(fontSize: 18)
    }
    
    func setButton() {
        continueButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        continueButton.layer.shadowColor = UIColor.darkGray.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        continueButton.layer.shadowRadius = 1
        continueButton.layer.shadowOpacity = 0.5
        continueButton.backgroundColor = .white
        continueButton.tintColor = .black
    }
    
    func updateContinueButton() {
        if phoneNumberTextField.hasText && passwordTextField.hasText {
            continueButton.isEnabled = true
            continueButton.tintColor = .black
        } else {
            continueButton.isEnabled = false
            continueButton.tintColor = .lightGray
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
