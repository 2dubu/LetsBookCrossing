import UIKit

final class NetworkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let alertController = UIAlertController(
            title: "네트워크에 접속할 수 없습니다",
            message: "네트워크 연결 상태를 확인해주세요.",
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: "재시도", style: .default) { _ in
            NetworkCheck.shared.startMonitoring()
        }

        let endAction = UIAlertAction(title: "종료", style: .default) { _ in
            // 앱 종료
            NetworkCheck.shared.startMonitoring()
            
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }

        alertController.addAction(retryAction)
        alertController.addAction(endAction)
        present(alertController, animated: true)
    }
}
