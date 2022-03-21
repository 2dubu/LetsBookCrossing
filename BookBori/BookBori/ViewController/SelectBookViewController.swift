//
//  SelectBookViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/22.
//

import UIKit

class SelectBookViewController: UIViewController {
    
    //MARK: - constant, variable

    let searchBar = UISearchBar()
    var filteredArray : [Book] = BookDummyData.shared.books  // 검색에 맞는 데이터만 필터링해서 담는 Book 배열
    
    var refreshControl = UIRefreshControl()
    var collectionViewHearderHeight = 28 + (UIScreen.main.bounds.width-40)*0.2
    
    //MARK: - viewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksCollectionView.refreshControl = refreshControl
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
    
        self.searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        self.booksCollectionView.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        
        searchBar.returnKeyType = .done
        
        setWhiteView()
        initSearchBar()
        
        defaultImageView.image = UIImage(named: "selectCollectionViewPlaceholder")
        defaultImageView.isHidden = true
    }
    

    // MARK: - IBOutlet & IBAction
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var defaultImageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        whiteView.isHidden = true
        collectionViewHearderHeight = 18
        booksCollectionView.reloadData()
    }
    
    //MARK: - function
    
    // 화면 탭하여 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func setWhiteView() {
        whiteView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        whiteView.layer.cornerRadius = 12
        whiteView.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        whiteView.layer.borderWidth = 0.5
        setViewShadow(view: whiteView, shadowRadius: 4, shadowOpacity: 0.3)
        
        descriptionLabel.dynamicFont(fontSize: 15)
    }
    
    // searchBar
    func initSearchBar() {
        self.navigationItem.titleView = searchBar
        searchBar.text = ""
        searchBar.placeholder = "신청하고 싶은 도서명을 검색하세요"
        searchBar.searchTextField.font = UIFont(name: "GmarketSansLight", size: 16)
        searchBar.searchTextField.backgroundColor = UIColor.clear
    }
    
    // 스크롤 뷰 아래에서 바운스 X
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
        scrollView.bounces = scrollView.contentOffset.y < 300
    }
    
    // refreshControl
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (refreshControl.isRefreshing) {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func refresh() {
        booksCollectionView.reloadData()
    }
    
}

//MARK: - searchBar

extension SelectBookViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray.removeAll()
        guard let text = searchBar.text else { return }
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
        // 검색 결과 없을 땐 defaultImage 표시
        if filteredArray.count == 0 {
            defaultImageView.isHidden = false
        } else {
            defaultImageView.isHidden = true
        }
    }
    
    // searchBar 완료 버튼 눌렀을 때 키보드 내리기
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        guard let text = self.searchBar.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.present(UtilitiesForAlert.returnAlert(title: "검색어를 입력해 주세요", msg: "", buttonTitle: "확인", handler: nil), animated: true, completion: nil)
        }
    }
    
}

//MARK: - collectionView
extension SelectBookViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = booksCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BooksCollectionViewCell
        
        cell.titleLabel.text = filteredArray[indexPath.row].title
        cell.coverImageView.image = UIImage(named: filteredArray[indexPath.row].image)
        
        // titleLabel dynamicFont
        cell.titleLabel.dynamicFont(fontSize: 11)
        
        return cell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width/3
        return CGSize(width: cellWidth, height: cellWidth*1.42)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bookApplied = BookDummyData.shared.books[indexPath.row]
        let guideVC = UIStoryboard(name: "Apply", bundle: nil).instantiateViewController(withIdentifier: "GuideVC")
        self.navigationController?.pushViewController(guideVC, animated: true)
    }
    
    // collectionView 상하단 공백 추가
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionViewHearderHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 22)
    }
}


