//
//  ViewModel.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-07.
//

import Foundation
import AuthenticationServices

class ViewModel: NSObject {
    
    weak var coordinator: Coordinator?

    func loginTapped() {
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
                    self?.getUser()
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
}

extension ViewModel {
    
    private func getUser() {
        NetworkRequest.RequestType.getUser.networkRequest()?.start(responseType: User.self, completionHandler: { [weak self] result in
            switch result {
            case .success(let networkResponse):
                DispatchQueue.main.async {
                    let user = networkResponse.object
                    //                    self?.userName = user.name
                    //                    self?.login = user.login
                    //                    self?.isShowingRepositoriesView = true
                    self?.loadRepositories()
                    self?.coordinator?.start()
//                    self?.showHomeScreen()
                    print("🟢 Login name: \(user.login) User name: \(user.name)")
                    print("\(user)")
                }
            case .failure(let error):
                print(" 🔴Failed to get user \(error.localizedDescription)")
            }
        })
    }
    
    private func loadRepositories() {
        NetworkRequest.RequestType.getRepositories.networkRequest()?.start(responseType: [Repository].self, completionHandler: { [weak self] result in
            switch result {
            case .success(let networkResponse):
                DispatchQueue.main.async {
//                    self?.repositories = networkResponse.object
                    let repositories = networkResponse.object
//                    self?.printRepo()
                    print(repositories)
                }
            case .failure(let error):
                print("🔴 Error to get repositories \(error)")
            }
        })
    }
    
//    func printRepo() {
//        print("start printing repo")
//        for (index, repository) in repositories.enumerated() {
//            print("🔸 \(index) \(repository.name) \(repository.id)")
//        }
//    }
    
    func showHomeScreen() {
//        let vc = storyboard?.instantiateViewController(identifier: "Home") as! HomeViewController
//        vc.user = userName
//        vc.login = login
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
        
        
    }
        
}

extension ViewModel: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first {$0.isKeyWindow}
        return window ?? ASPresentationAnchor()
    }
}

