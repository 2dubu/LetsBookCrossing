//
//  CheckViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/03/31.
//

import UIKit

class CheckViewController: UIViewController {

    @IBOutlet weak var checkTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
        
        checkTableView.delegate = self
        checkTableView.dataSource = self
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension CheckViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExchangeHistoryDummyData.shared.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckTableViewCell
        let histories = ExchangeHistoryDummyData.shared.histories
        
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        
        // set elements
        cell.whiteView.layer.cornerRadius = 15
        cell.whiteView.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cell.whiteView.layer.borderWidth = 0.5
        setViewShadow(view: cell.whiteView, shadowRadius: 3, shadowOpacity: 0.3)
        cell.cancelButton.layer.cornerRadius = UIScreen.main.bounds.width/50
        setButtonShadow(button: cell.cancelButton, shadowRadius: 3, shadowOpacity: 0.3)
        cell.countView.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        cell.countView.layer.borderWidth = 0.5

        // dynamicFont
        cell.countLabel.dynamicFont(fontSize: 18)
        cell.applyDateLabel.dynamicFont(fontSize: 17)
        cell.registerLabel.dynamicFont(fontSize: 19)
        cell.applyLabel.dynamicFont(fontSize: 19)
        cell.registerTitleLabel.dynamicFont(fontSize: 15)
        cell.applyTitleLabel.dynamicFont(fontSize: 15)
        cell.cancelButton.titleLabel?.dynamicFont(fontSize: 17)
        
        // enter content
        cell.countLabel.text = String(histories.count-indexPath.row)
        cell.applyDateLabel.text = histories[indexPath.row].applyDate
        cell.registerImageView.image = UIImage(named: histories[indexPath.row].registeredBookImage)
        cell.applyImageView.image = UIImage(named: histories[indexPath.row].applieddBookImage)
        cell.registerTitleLabel.text = histories[indexPath.row].registeredBookTitle
        cell.applyTitleLabel.text = histories[indexPath.row].applieddBookTitle
        
        return cell
    }
    
    // tableView 하단 공백 추가
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: Int(tableView.frame.height), width: Int(tableView.frame.width), height: 15))
        return footerView
    }
    
}
