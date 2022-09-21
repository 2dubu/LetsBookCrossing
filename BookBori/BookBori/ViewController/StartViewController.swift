//
//  StartViewController.swift
//  BookBori
//
//  Created by 건우 on 2021/06/29.
//

import UIKit

class StartViewController: UIViewController {
    
    final class FirstLaunch {
        let wasLaunchedBefore: Bool
        var isFirstLaunch: Bool { return !wasLaunchedBefore }
        init(getWasLaunchedBefore: () -> Bool,
             setWasLaunchedBefore: (Bool) -> ()) {
            let wasLaunchedBefore = getWasLaunchedBefore()
            self.wasLaunchedBefore = wasLaunchedBefore
            if !wasLaunchedBefore { setWasLaunchedBefore(true) }
        }
        convenience init(userDefaults: UserDefaults, key: String) {
            self.init(getWasLaunchedBefore: { userDefaults.bool(forKey: key) }, setWasLaunchedBefore: { userDefaults.set($0, forKey: key) })
        }
    }
    
    // 첫 실행인지 확인
    let fistLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
    
    // 항상 첫 실행으로 (테스트용)
    let alwaysFirstLaunch = FirstLaunch(getWasLaunchedBefore: { return false }, setWasLaunchedBefore: { _ in })
    
    //MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        let mainNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNC")
        mainNav.modalPresentationStyle = .fullScreen
        mainNav.modalTransitionStyle = .crossDissolve
        self.present(mainNav, animated: true, completion: nil)
        UIView.transition(with: self.view, duration: 1.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
