//
//  RepositoriesViewController.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-04.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    var repositories: [Repository] = []
    let username: String
    
    init() {
        self.repositories = []
        self.username = NetworkRequest.username ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(repositories: [Repository], username: String) {
        self.repositories = repositories
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRepositories()
        
        
    }
    
    func loadRepositories() {
        NetworkRequest.RequestType.getRepositories.networkRequest()?.start(responseType: [Repository].self, completionHandler: { [weak self] result in
            switch result {
            case .success(let networkResponse):
                DispatchQueue.main.async {
                    self?.repositories = networkResponse.object
                    print("RESULT: \(result)")
                }
            case .failure(let error):
                print("🔴 Error to get repositories \(error)")
            }
        })
    }
    
    
}
