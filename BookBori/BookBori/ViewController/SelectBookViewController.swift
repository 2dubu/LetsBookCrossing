//
//  SelectBookViewController.swift
//  BookBori
//
//  Created by 이로운 on 2022/02/22.
//

import UIKit
import Kingfisher

class SelectBookViewController: UIViewController {
    
    //MARK: - constant, variable

    let searchBar = UISearchBar()
    var baseArray: [BookData] = (SeoulBookBogoDataManager.shared.applicableBookList?.data.bookList)!
    var filteredArray: [BookData] = []
    var isBaseArray = true
    
    var currentPage: Int = 1
    var currentPageForSearch: Int = 1
    var fetchingMore = true
    
    var refreshControl = UIRefreshControl()
    var collectionViewHearderHeight = 28 + (UIScreen.main.bounds.width-40)*0.2
    
    //MARK: - viewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.isHidden = true
        self.view.bringSubviewToFront(self.indicatorView)
        
        booksCollectionView.refreshControl = refreshControl
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
    
        self.searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        self.booksCollectionView.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        
        setWhiteView()
        initSearchBar()
        setScrollUpButton()
        
        defaultImageView.image = UIImage(named: "selectCollectionViewPlaceholder")
        defaultImageView.isHidden = true
        
        self.view.bringSubviewToFront(self.refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침 중...",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont(name: "GmarketSansMedium", size: 20)])
    }
    

    // MARK: - IBOutlet & IBAction
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var defaultImageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var scrollUpButton: UIButton!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func descriptionCancelButtonTapped(_ sender: Any) {
        whiteView.isHidden = true
        collectionViewHearderHeight = 18
        booksCollectionView.reloadData()
    }
    
    @IBAction func scrollUpButtonTapped(_ sender: Any) {
        self.booksCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    //MARK: - function
    
    // 화면 탭하여 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func setScrollUpButton() {
        
        let imageConfig = UIImage.SymbolConfiguration(scale: .medium)
        let arrowUp = UIImage(systemName: "arrow.up", withConfiguration: imageConfig)
        
        scrollUpButton.tintColor = tintColor
        scrollUpButton.layer.cornerRadius = UIScreen.main.bounds.width*0.14/2
        scrollUpButton.backgroundColor = .white
        scrollUpButton.setImage(arrowUp, for: .normal)
        scrollUpButton.setTitle("", for: .normal)
        scrollUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollUpButton.layer.shadowOpacity = 0.4
        scrollUpButton.layer.shadowOffset = .zero
        scrollUpButton.layer.shadowRadius = 3
        scrollUpButton.layer.shadowColor = UIColor.black.cgColor
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .search, primaryAction: UIAction(handler: { _ in
            self.showSearchResult()
        }))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)
        searchBar.text = ""
        searchBar.placeholder = "신청하고 싶은 도서명을 검색하세요"
        searchBar.searchTextField.font = UIFont(name: "GmarketSansLight", size: 16)
        searchBar.searchTextField.backgroundColor = UIColor.clear
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    }
    
    func showSearchResult() {
        self.searchBar.endEditing(true)
        guard let text = self.searchBar.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showAlert1(title: "안내", message: "검색어를 입력해주세요", buttonTitle: "확인", handler: nil)
        } else  {
            filteredArray.removeAll()
            print("지금 몇개야?", filteredArray.count)
            
            // 검색된 키워드가 포함된 도서명의 데이터만 서버로부터 불러오기 
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
            
            getApplicableBookList(pagesize: 21, page: self.currentPage, keyword: text) { [self] in
                self.filteredArray = SeoulBookBogoDataManager.shared.applicableBookList?.data.bookList ?? []
                isBaseArray = false
                self.booksCollectionView.reloadData()
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true
                
                print("!!!!!!!!!!!!!", filteredArray)
                
                // 검색 결과 없을 땐 defaultImage 표시
                if SeoulBookBogoDataManager.shared.applicableBookList?.data.listCount == 0 && (DeviceManager.shared.networkStatus) == true {
                    defaultImageView.isHidden = false
                    booksCollectionView.isScrollEnabled = false
                } else {
                    defaultImageView.isHidden = true
                    booksCollectionView.isScrollEnabled = true
                }
            }
        }
    }
    
    // 애니메이션이 끝난 후 스크롤뷰의 가장 아래일 때 실행
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
                
        if offsetY > contentHeight - scrollView.frame.height {
            if SeoulBookBogoDataManager.shared.applicableBookList?.data.nextPage == "Y" && fetchingMore {
                
                fetchingMore = false
                self.indicatorView.isHidden = false
                self.indicatorView.startAnimating()
                
                // 만약 도서를 검색한 상태라면
                if self.searchBar.text?.isEmpty == false {
                    currentPageForSearch += 1
                    getApplicableBookList(pagesize: 21, page: self.currentPageForSearch, keyword: self.searchBar.text!) {
                        self.booksCollectionView.reloadData()
                        self.indicatorView.stopAnimating()
                        self.indicatorView.isHidden = true
                        self.fetchingMore = true
                    }
                } else {
                    currentPage += 1
                    getApplicableBookList(pagesize: 21, page: self.currentPage, keyword: "") {
                        self.baseArray += (SeoulBookBogoDataManager.shared.applicableBookList?.data.bookList ?? [])
                        self.booksCollectionView.reloadData()
                        self.indicatorView.stopAnimating()
                        self.indicatorView.isHidden = true
                        self.fetchingMore = true
                    }
                }
            }
        }
    }
    
    // refreshControl
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (refreshControl.isRefreshing) {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func refresh() {
        self.currentPage = 1
        baseArray.removeAll()
        getApplicableBookList(pagesize: 21, page: 1, keyword: "") {
            self.baseArray += (SeoulBookBogoDataManager.shared.applicableBookList?.data.bookList ?? [])
            self.booksCollectionView.reloadData()
        }
    }
    
}

//MARK: - searchBar

extension SelectBookViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = self.searchBar.text else { return }
        if text.isEmpty {
            // X버튼 또는 서치바에 있는 텍스트가 모두 지워졌을 때
            self.booksCollectionView.reloadData()
            defaultImageView.isHidden = true
            booksCollectionView.isScrollEnabled = true
            isBaseArray = true
        }
    }
    
    // searchBar 완료 버튼 눌렀을 때 검색 결과 띄우기
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearchResult()
    }
    
}

//MARK: - collectionView
extension SelectBookViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func returnArray() -> [BookData] {
        if isBaseArray == true {
            return baseArray
        } else {
            return filteredArray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        returnArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = booksCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BooksCollectionViewCell
        
        cell.titleLabel.text = returnArray()[indexPath.row].bookTitle
        cell.coverImageView.kf.indicatorType = .activity
        cell.coverImageView.kf.setImage(
            with: URL(string: returnArray()[indexPath.row].imgUrl),
            placeholder: UIImage(named: "imageNotFound"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.7)),
                .cacheOriginalImage
            ])
        
        // titleLabel dynamicFont
        cell.titleLabel.dynamicFont(fontSize: 11)
        
        return cell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
        
        applyBookPK = returnArray()[indexPath.row].bookPK
        applyBookTitle = returnArray()[indexPath.row].bookTitle
        applyBookImgURL = returnArray()[indexPath.row].imgUrl
        
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


