//
//  GuideViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/23.
//

import UIKit

class GuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 신청할 도서 정보 표시
        guard let book = bookApplied else { return }
        bookCoverImageView.image = UIImage(named: book.image)
        bookTitleLabel.text = book.title
        bookDetailLabel.text = "저자 : \(book.author)\n출판사 : \(book.publisher)\n발행연도 : \(book.yearPublished)"
    }
    
    
    // MARK: - IBOutlet & IBAction
    
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDetailLabel: UILabel!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
