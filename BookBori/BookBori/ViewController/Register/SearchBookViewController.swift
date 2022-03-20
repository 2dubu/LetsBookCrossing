//
//  SearchBookViewController.swift
//  BookBori
//
//  Created by 이로운 on 2021/09/13.
//

import UIKit
import Kingfisher
import Alamofire

class SearchBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let jsconDecoder: JSONDecoder = JSONDecoder()
    let searchBar = UISearchBar()
    let transfrom = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
    
    @IBOutlet weak var searchBookTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var defaultImage: UIImageView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        searchBookTableView.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        
        dataManager.shared.searchResultOfNaver?.items.removeAll()
        searchBookTableView.reloadData()
        
        searchBookTableView.delegate = self
        searchBookTableView.dataSource = self
        self.searchBar.delegate = self
        
        self.view.bringSubviewToFront(self.indicatorView)
        indicatorView.transform = transfrom
        indicatorView.isHidden = true
        
        defaultImage.image = UIImage(named: "searchTableViewPlaceholder1")
        
        initSearchBar()
    }
    
    // 화면 탭하여 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func initSearchBar() {
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .search, primaryAction: UIAction(handler: { _ in
            self.showSearchResult()
        }))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3300665617, green: 0.614702642, blue: 0.3727215827, alpha: 1)
        searchBar.text = ""
        searchBar.placeholder = "등록하고 싶은 도서명을 검색하세요"
        searchBar.searchTextField.font = UIFont(name: "GmarketSansLight", size: 16)
        searchBar.searchTextField.backgroundColor = UIColor.clear
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    }
    
    func showSearchResult() {
        self.searchBar.endEditing(true)
        guard let text = self.searchBar.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.present(UtilitiesForAlert.returnAlert(title: "검색어를 입력해 주세요", msg: "", buttonTitle: "확인", handler: nil), animated: true, completion: nil)
        } else  {
            if let queryValue: String = self.searchBar.text {
                requestBookBySearch(queryValue) { result in
                    switch result {
                    case .success(_):
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.indicatorView.stopAnimating()
                            self.indicatorView.isHidden = true
                            self.searchBookTableView.reloadData()
                            
                            if (DeviceManager.shared.networkStatus) == true && dataManager.shared.searchResultOfNaver?.items.isEmpty == true {
                                self.defaultImage.image = UIImage(named: "searchTableViewPlaceholder2")
                                self.defaultImage.isHidden = false
                            }
                            
                        }
                    case .failure(let error):
                        print("error : \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearchResult()
    }
    
    func requestBookBySearch(
        _ query: String,
        _ completion: @escaping (Result<SearchResultOfNaver, Error>) -> ()
    ) {
        let baseURL = "https://openapi.naver.com/v1/search/book.json?query="
        let url = baseURL + "\(query)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "SLVdtD48toDlPkzUQcqQ",
            "X-Naver-Client-Secret": "6OoqxoUJPT",
            "Content-Type": "application/json; charset=utf-8"
        ]
        if let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            checkDeviceNetworkStatus()
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
            
//            AF.sessionConfiguration.timeoutIntervalForRequest = 5
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 10 // seconds
            configuration.timeoutIntervalForResource = 10
            AF
                .request(urlEncoding, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 5 })
                .responseJSON { response in
                    switch response.result {
                    case .success(let jsonData):
                        do {
                            let json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                            let searchInfo = try JSONDecoder().decode(SearchResultOfNaver.self, from: json)
                            
                            dataManager.shared.searchResultOfNaver = searchInfo
                            completion(.success(searchInfo))
                        } catch(let error) {
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            let timeOutAlert : UIAlertController = UIAlertController(title: "요청 시간 초과",
                                message: """
                                네트워크가 불안정합니다.
                                네트워크 상태를 확인해주세요.
                                """,
                                preferredStyle: .alert)
                            let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                                
                            })
                            okAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
                            timeOutAlert.addAction(okAction)
                            self.present(timeOutAlert, animated: true, completion: nil)
                        }
                        completion(.failure(error))
                    }
                }
        }
    }
    
    private func checkDeviceNetworkStatus() {
        if(DeviceManager.shared.networkStatus) == false {
            // 네트워크 연결 X
            OperationQueue.main.addOperation {
                
            }
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            let alert : UIAlertController = UIAlertController(title: "서버에 연결할 수 없습니다",
                message: """
                네트워크가 연결되지 않았습니다.
                Wi-Fi 또는 데이터를 활성화 해주세요.
                """,
                preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                
            })
            let againAction: UIAlertAction = UIAlertAction(title: "다시 시도", style: .default, handler: { _ in
//                self.searchBarSearchButtonClicked(self.searchBar)
            })
            okAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
            againAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
            alert.addAction(okAction)
            alert.addAction(againAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func getFilterdData() -> [SearchResultOfNaver.BookInfo] {
        let filteredItem = dataManager.shared.searchResultOfNaver?.items.filter({ item in
            if item.title == "" || item.image == "" || item.author == "" || item.pubdate == "" {
                return false
            } else {
                return true
            }
        })
        return filteredItem ?? []
    }
    
    // MARK: - TableViewController
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if getFilterdData().isEmpty == true {
            return 0
        } else {
            return getFilterdData().count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! SearchBookTableViewCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.9164562225, green: 0.9865346551, blue: 0.8857880235, alpha: 1)
        self.defaultImage.isHidden = true
        
        let filteredItem = dataManager.shared.searchResultOfNaver?.items.filter({ item in
            if item.title == "" || item.image == "" || item.author == "" || item.pubdate == "" {
                return false
            } else {
                return true
            }
        })
        
        if let item = filteredItem?[indexPath.row] {
            
            guard let url = URL(string: item.image) else { return cell }
            cell.bookImageView.kf.indicatorType = .activity
            cell.bookImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "imageNotFound"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.7)),
                    .cacheOriginalImage
                ])

            cell.bookTitleLabel.text = item.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
            
            /*
            if item.authors.count == 1 {
                cell.bookAuthorLabel.text = item.authors[0]
            } else if item.authors.count > 1 {
                cell.bookAuthorLabel.text = "\(item.authors[0]) 외 \(item.authors.count-1)명"
            } */
            
            cell.bookAuthorLabel2.text = item.author.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
            cell.bookCompanyLabel2.text = item.publisher.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
            cell.bookDayLabel2.text = item.pubdate
        }
        
        // DynamicFont
        cell.bookTitleLabel.dynamicFont(fontSize: 17)
        cell.bookAuthorLabel1.dynamicFont(fontSize: 13)
        cell.bookAuthorLabel2.dynamicFont(fontSize: 12)
        cell.bookCompanyLabel1.dynamicFont(fontSize: 13)
        cell.bookCompanyLabel2.dynamicFont(fontSize: 12)
        cell.bookDayLabel1.dynamicFont(fontSize: 13)
        cell.bookDayLabel2.dynamicFont(fontSize: 12)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let directInputVC = self.storyboard?.instantiateViewController(identifier: "DirectInputVC") as? DirectInputViewController else { return }
        self.navigationController?.pushViewController(directInputVC, animated: true)
            
        if let index = searchBookTableView.indexPathsForSelectedRows {
            let userSelectedSearchBookNumber = index[0].row+1
            directInputVC.indexPath = userSelectedSearchBookNumber
        }
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
