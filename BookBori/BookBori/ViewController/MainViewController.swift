//
//  MainViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!

    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBAction
    @IBAction func applyButtonTapped(_ sender: Any) {
        let applySB = UIStoryboard(name: "Apply", bundle: nil)
        let selectBookVC = applySB.instantiateViewController(withIdentifier: "SelectBookVC")
        self.navigationController?.pushViewController(selectBookVC, animated: true)
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        let checkSB = UIStoryboard(name: "Check", bundle: nil)
        let checkVC = checkSB.instantiateViewController(withIdentifier: "CheckVC")
        self.navigationController?.pushViewController(checkVC, animated: true)
    }
    
    //MARK: - Functions


}
