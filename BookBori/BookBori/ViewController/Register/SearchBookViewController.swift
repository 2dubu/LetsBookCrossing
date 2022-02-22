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
    let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
    
    @IBOutlet weak var searchBookTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var defaultImage: UIImageView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataManager.shared.searchResultOfKakao?.documents.removeAll()
        searchBookTableView.reloadData()
        
        searchBookTableView.delegate = self
        searchBookTableView.dataSource = self
        searchBookTableView.separatorStyle = .none
        self.searchBar.delegate = self
        
        self.view.bringSubviewToFront(self.indicatorView)
        indicatorView.transform = transfrom
        indicatorView.isHidden = true
        
        defaultImage.image = UIImage(named: "searchTableViewPlaceholder1")
        
        initSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // 화면 탭하여 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func initSearchBar() {
        searchBar.text = ""
        searchBar.placeholder = "책을 검색해보세요"
        self.navigationItem.titleView = searchBar
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.backgroundColor = UIColor.clear
        searchBar.tintColor = #colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)
    }

    /*
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBookTableView.contentOffset = CGPoint(x: 0, y: 0 - searchBookTableView.contentInset.top)
        guard let text = self.searchBar.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            let noKeywordalert : UIAlertController = UIAlertController(title: "검색어를 입력해 주세요", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            okAction.setValue(UIColor(#colorLiteral(red: 0.6823529412, green: 0.5725490196, blue: 0.4039215686, alpha: 1)), forKey: "titleTextColor")
            noKeywordalert.addAction(okAction)
            self.present(noKeywordalert, animated: true, completion: nil)
        } else  {
            if let queryValue: String = self.searchBar.text {
                requestBookBySearch(queryValue) { result in
                    switch result {
                    case .success(_):
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.indicatorView.stopAnimating()
                            self.indicatorView.isHidden = true
                            self.searchBookTableView.separatorStyle = .singleLine
                            self.searchBookTableView.reloadData()
                            
                            if (DeviceManager.shared.networkStatus) == true && dataManager.shared.searchResultOfKakao?.documents.isEmpty == true {
                                self.searchBookTableView.separatorStyle = .none
                                self.defaultImage.image = UIImage(named: "searchTableViewPlaceholder2")
                                self.defaultImage.isHidden = false
                            }
                            
                        }
                    case .failure(let error):
                        print("error : \(error.localizedDescription)")
                        // 이거 잘뜨네
                    }
                }
            }
        }
    }
     */
    
    /*
    func requestBookBySearch(
        _ query: String,
        _ completion: @escaping (Result<SearchResultOfKakao, Error>) -> ()
    ) {
        let baseURL = "https://dapi.kakao.com/v3/search/book?target="
        let url = baseURL + "title&query=" + "\(query)"
        let RestAPIKEY: String = "a020fb7fae0b849fa5e0ca6f9b039d9c"
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(RestAPIKEY)",
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
                            let searchInfo = try JSONDecoder().decode(SearchResultOfKakao.self, from: json)
                            
                            dataManager.shared.searchResultOfKakao = searchInfo
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
     */
    
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
    
    /*
    func getFilterdData() -> [SearchResultOfKakao.BookInfo] {
        let filteredItem = dataManager.shared.searchResultOfKakao?.documents.filter({ item in
            if item.title == "" || item.thumbnail == "" || item.authors == [] || item.datetime == "" {
                return false
            } else {
                return true
            }
        })
        return filteredItem ?? []
    }
     */
    
    // MARK: - TableViewController
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if getFilterdData().isEmpty == true {
//            return 0
//        } else {
//            return getFilterdData().count
//        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! SearchBookTableViewCell
        cell.selectionStyle = .none
        self.defaultImage.isHidden = true
        
        let filteredItem = dataManager.shared.searchResultOfKakao?.documents.filter({ item in
            if item.title == "" || item.thumbnail == "" || item.authors == [] {
                return false
            } else {
                return true
            }
        })
        
        if let item = filteredItem?[indexPath.row] {
            
            guard let url = URL(string: item.thumbnail) else { return cell }
            cell.bookImageView.kf.indicatorType = .activity
            cell.bookImageView.kf.setImage(
                with: url,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])

            cell.bookTitleLabel.text = item.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
            if item.authors.count == 1 {
                cell.bookAuthorLabel.text = item.authors[0]
            } else if item.authors.count > 1 {
                cell.bookAuthorLabel.text = "\(item.authors[0]) 외 \(item.authors.count-1)명"
            }
        }
        */
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! UITableViewCell
        
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
}
