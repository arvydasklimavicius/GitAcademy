//
//  ViewController.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-06-17.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let viewModel = ViewModel()
    private let userViewModel = UserViewModel()
    private let loginViewModel = LoginViewModel()
    
    let loginCoordinator = Coordinator()
    weak var coordinator: Coordinator?
    
    var isShowingRepositoriesView = false
    var repositories: [Repository] = []
    var userName: String = ""
    var login: String = ""
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var githubLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = loginCoordinator
        setupUI()
        
        userViewModel.userFetchCompletion = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.coordinator?.startHomeViewController(with: strongSelf.userViewModel, rootVC: strongSelf)
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
//        viewModel.loginTapped()
//        userViewModel.start()
        loginViewModel.loginTapped()

    }
    
    func loginTapped() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let loginURL = NetworkRequest.RequestType.login.networkRequest()?.url else {
            print("🔴 Can't create login URL")
            return
        }
        
        let callbackURL = NetworkRequest.callbackURLScheme
        let authenticationServices = ASWebAuthenticationSession(url: loginURL, callbackURLScheme: callbackURL) { [weak self] callbackURL, error in
            guard
                error == nil,
                let callbackURL = callbackURL,
                let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
                let code = queryItems.first(where: { $0.name == "code" })?.value,
                let networkRequest = NetworkRequest.RequestType.codeExchange(code: code).networkRequest()
            else {
                print("🔴 Error while login")
                return
            }
            
            networkRequest.start(responseType: String.self) { result in
                switch result {
                case .success:
                    self?.userViewModel.start()
                case .failure(let error):
                    print("🔴 Failed to exchange token \(error)")
                }
            }
        }
        authenticationServices.presentationContextProvider = self
        authenticationServices.prefersEphemeralWebBrowserSession = true
        
        if !authenticationServices.start() {
            print("🔴 Failed to start ASWebAuthenticationSession")
        }
    }
    
    private func loadRepositories() {
        NetworkRequest.RequestType.getRepositories.networkRequest()?.start(responseType: [Repository].self, completionHandler: { [weak self] result in
            switch result {
            case .success(let networkResponse):
                DispatchQueue.main.async {
                    self?.repositories = networkResponse.object
                    self?.printRepo()
                }
            case .failure(let error):
                print("🔴 Error to get repositories \(error)")
            }
        })
    }
    
    func printRepo() {
        print("start printing repo")
        for (index, repository) in repositories.enumerated() {
            print("🔸 \(index) \(repository.name) \(repository.id)")
        }
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
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        return window ?? ASPresentationAnchor()
    }
}

