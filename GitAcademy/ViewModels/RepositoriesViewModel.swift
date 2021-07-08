//
//  RepositoriesViewModel.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-08.
//

import Foundation

final class RepositoriesViewModel {
    
    var repositories: [Repository] = []
    
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
    
}
