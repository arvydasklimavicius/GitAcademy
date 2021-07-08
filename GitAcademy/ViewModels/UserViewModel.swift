//
//  UserViewModel.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-08.
//

import Foundation

final class UserViewModel {
    
    private var username: String?
    private var login: String?
    
    var userFetchCompletion: (() -> Void)?
    
    func start() {
        getUser()
    }
    
    func getUsername() -> String? {
        username
    }
    
    func getLogin() -> String? {
        login
    }
}

extension UserViewModel {
    
    private func getUser() {
        NetworkRequest.RequestType.getUser.networkRequest()?.start(responseType: User.self, completionHandler: { [weak self] result in
            switch result {
            case .success(let networkResponse):
                DispatchQueue.main.async {
                    let user = networkResponse.object
                    self?.username = user.name
                    self?.login = user.login
                    self?.userFetchCompletion?()
                    print("🟢 Login name: \(user.login) User name: \(user.name)")
                    print("\(user)")
                }
            case .failure(let error):
                print(" 🔴Failed to get user \(error.localizedDescription)")
            }
        })
    }
}
