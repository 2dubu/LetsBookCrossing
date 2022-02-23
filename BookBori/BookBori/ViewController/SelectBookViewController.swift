//
//  SelectBookViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/22.
//

import UIKit

class SelectBookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    //MARK: - constant, variable

    let searchBar = UISearchBar()
    var filteredArray : [Book] = BookDummyData.shared.books  // 검색에 맞는 데이터만 필터링해서 담는 Book 배열
    
    //MARK: - viewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        self.searchBar.delegate = self

        initSearchBar()
    }
    

    //MARK: - IBAction, IBOutlet
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var booksCollectionView: UICollectionView!
    
    
    //MARK: - function
    
    private func initSearchBar() {
        searchBar.text = ""
        searchBar.placeholder = "책을 검색해 보세요"
        self.navigationItem.titleView = searchBar
        //searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.backgroundColor = UIColor.clear
    }
    
    
    //MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = booksCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BooksCollectionViewCell
        
        cell.titleLabel.text = filteredArray[indexPath.row].title
        cell.coverImageView.image = UIImage(named: filteredArray[indexPath.row].image)
        
        return cell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3+10)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bookApplied = BookDummyData.shared.books[indexPath.row]
        let guideVC = UIStoryboard(name: "Apply", bundle: nil).instantiateViewController(withIdentifier: "GuideVC")
        self.navigationController?.pushViewController(guideVC, animated: true)
    }

    
    //MARK: - searchBar
    
    // 검색 바에 텍스트가 비어있을 때 alert 표시
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.present(UtilitiesForAlert.returnAlert(title: "검색어를 입력해 주세요", msg: "", buttonTitle: "확인", handler: nil), animated: true, completion: nil)
        }
    }
    
    // 검색 바 텍스트가 바뀔 때마다 검색 결과 업데이트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        filteredArray.removeAll()
        for i in BookDummyData.shared.books {
            if i.title.lowercased().contains(text.lowercased()) {
                filteredArray.append(i)
            }
        }
        // 검색 바에 텍스트가 비어있을 때는 모든 데이터 표시
        if text.trimmingCharacters(in: .whitespaces).isEmpty == true {
            filteredArray = BookDummyData.shared.books
        }
        self.booksCollectionView.reloadData()
    }
    

}
