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

}

extension CheckViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckTableViewCell
        
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        
        cell.whiteView.layer.cornerRadius = 15
        cell.whiteView.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cell.whiteView.layer.borderWidth = 0.5
        setViewShadow(view: cell.whiteView, shadowRadius: 3, shadowOpacity: 0.3)
        
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
