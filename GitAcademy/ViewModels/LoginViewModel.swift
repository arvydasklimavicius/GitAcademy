//
//  LoginViewModel.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-08.
//

import Foundation
import AuthenticationServices

final class LoginViewModel: NSObject {
    
//    private let userViewModel = UserViewModel()
    
    var completion: (() -> Void)?
    
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
                    self?.completion?()
//                    self?.userViewModel.start()
                    //TO DO need to show home vc...
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

extension LoginViewModel: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first {$0.isKeyWindow}
        return window ?? ASPresentationAnchor()
    }
}
