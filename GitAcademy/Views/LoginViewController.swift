//
//  ViewController.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-06-17.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    
    let loginCoordinator = AppDelegate.coordinator
    weak var coordinator: Coordinator?
    
    var userName: String = ""
    var login: String = ""
    var followers: Int = 0
    var following: Int = 0
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var githubLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = loginCoordinator
        setupUI()
        
        loginViewModel.completion = { [weak self ] in
            guard let strongSelf = self else { return }
            strongSelf.coordinator?.startHomeViewController(rootVC: strongSelf)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginViewModel.loginTapped()
    }
    
    func setupUI() {
        githubLoginButton.layer.borderColor = UIColor.white.cgColor
        githubLoginButton.layer.borderWidth = 1
        githubLoginButton.layer.cornerRadius = 8
        activityIndicator.isHidden = true
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first {$0.isKeyWindow}
        return window ?? ASPresentationAnchor()
    }
}

