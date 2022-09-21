//
//  ScanBarcodeViewController.swift
//  BookBori
//
//  Created by 이로운 on 2021/10/14.
//

import UIKit
import AVFoundation
import Alamofire

class ScanBarcodeViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var avLayerView: UIView!
    
    //MARK: - variables
    let jsconDecoder: JSONDecoder = JSONDecoder()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: 18)!]
        
        self.view.bringSubviewToFront(self.indicatorView)
        indicatorView.transform = transfrom
        indicatorView.isHidden = true
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = avLayerView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        avLayerView.layer.addSublayer(previewLayer)
        setCenterGuideLineView()
        
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    //MARK: - IBAction, IBOutlet
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - functions
    
    func requestBookByScan(
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
            checkDeviceNetworkStatusToScanBarcode {
                self.indicatorView.isHidden = false
                self.indicatorView.startAnimating()
                
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
                            completion(.failure(error))
                        }
                    }
            }
        }
    }
    
    private func checkDeviceNetworkStatusToScanBarcode(completion: @escaping ()->()) {
        if(DeviceManager.shared.networkStatus) == false {
            // 네트워크 연결 X
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            showAlert2(title: "서버에 연결할 수 없습니다", message: "네트워크가 연결되지 않았습니다.\nWi-Fi 또는 데이터를 활성화 해주세요.", buttonTitle1: "다시 시도", buttonTitle2: "확인") { _ in
                self.captureSession.startRunning()
            } handler2: { _ in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            completion()
        }
    }
    
    private func setCenterGuideLineView() {
        let centerGuideLineView = UIView()
        let centerGuideLineView2 = UIView()
        
        centerGuideLineView.translatesAutoresizingMaskIntoConstraints = false
        centerGuideLineView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.6156862745, blue: 0.3764705882, alpha: 1)
        avLayerView.addSubview(centerGuideLineView)
        avLayerView.bringSubviewToFront(centerGuideLineView)
        
        centerGuideLineView2.translatesAutoresizingMaskIntoConstraints = false
        centerGuideLineView2.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.6156862745, blue: 0.3764705882, alpha: 1)
        avLayerView.addSubview(centerGuideLineView2)
        avLayerView.bringSubviewToFront(centerGuideLineView2)
        
        NSLayoutConstraint.activate([
            centerGuideLineView.widthAnchor.constraint(equalToConstant: 30),
            centerGuideLineView.centerXAnchor.constraint(equalTo: avLayerView.centerXAnchor),
            centerGuideLineView.centerYAnchor.constraint(equalTo: avLayerView.centerYAnchor),
            centerGuideLineView.heightAnchor.constraint(equalToConstant: 1),
            
            centerGuideLineView2.widthAnchor.constraint(equalToConstant: 1),
            centerGuideLineView2.centerXAnchor.constraint(equalTo: avLayerView.centerXAnchor),
            centerGuideLineView2.centerYAnchor.constraint(equalTo: avLayerView.centerYAnchor),
            centerGuideLineView2.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //MARK: - overrides
    override var prefersStatusBarHidden: Bool { return false }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
}

extension ScanBarcodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print("isbn = \(stringValue)")
            requestBookByScan(stringValue) { result in
                switch result {
                case .success(_):
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.indicatorView.stopAnimating()
                        self.indicatorView.isHidden = true
                        
                        if (DeviceManager.shared.networkStatus) == true && dataManager.shared.searchResultOfNaver?.items.isEmpty == true {
                            self.showAlert1(title: "검색 결과가 없습니다", message: "검색 결과가 없습니다. 다른 등록 방법을 사용해주세요.", buttonTitle: "확인") { _ in
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            self.checkApplicable(bookPK: ExchangeDataManager.shared.applyBookInfo?.bookPK ?? "") {
                                guard let directInputVC = self.storyboard?.instantiateViewController(identifier: "DirectInputVC") else { return }
                                self.navigationController?.pushViewController(directInputVC, animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func failed() {
        self.showAlert1(title: "스캔이 지원되지 않습니다", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", buttonTitle: "확인", handler: nil)
        captureSession = nil
    }
}
