//
//  CheckViewController.swift
//  BookBori
//
//  Created by 이건우 on 2022/02/22.
//

import UIKit

class CheckViewController: UIViewController {

    @IBOutlet weak var exchangeHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exchangeHistoryTableView.delegate = self
        exchangeHistoryTableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "xmark")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// tableView
extension CheckViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExchangeHistoryDummyData.shared.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeHistoryCell", for: indexPath) as! ExchangeHistoryTableViewCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        
        let dummyData = ExchangeHistoryDummyData.shared.histories
        
        cell.registeredBookTitleLabel.text = dummyData[indexPath.row].registeredBookTitle
        cell.appliedBookTitleLabel.text = dummyData[indexPath.row].applieddBookTitle
        cell.registeredBookImageView.image = UIImage(named: dummyData[indexPath.row].registeredBookImage)
        cell.appliedBookImageView.image = UIImage(named: dummyData[indexPath.row].applieddBookImage)
        
        return cell
    }
}
