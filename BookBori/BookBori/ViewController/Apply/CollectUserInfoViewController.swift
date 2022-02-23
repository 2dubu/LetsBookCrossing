//
//  CollectUserInfoViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/23.
//

import UIKit

class CollectUserInfoViewController: UIViewController {
    
    // MARK: - viewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicFont()
        setButton()

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
    
    
    // MARK: - function
    
    func dynamicFont() {
        collectUserInfoTitleLabel.dynamicFont(fontSize: 26, weight: .bold)
        phoneNumberLabel.dynamicFont(fontSize: 17, weight: .semibold)
        passwordLabel.dynamicFont(fontSize: 17, weight: .semibold)
        continueButton.titleLabel?.dynamicFont(fontSize: 18, weight: .medium)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
