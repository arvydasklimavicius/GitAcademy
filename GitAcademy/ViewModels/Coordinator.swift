//
//  Coordinator.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-07.
//

import UIKit

class Coordinator {
//    var viewController: UIViewController
//
//    init(controller: UIViewController) {
//        self.viewController = controller
//    }
//
//    func startHomeViewController() {
//        let homeVC = HomeViewController()
//        homeVC.coordinator = self
//        homeVC.modalPresentationStyle = .fullScreen
//        viewController.p
//    }
    
    var navigationController: UINavigationController
        weak var presenter: UIViewController?

        init(navigationController: UINavigationController) {
            self.navigationController = navigationController
        }

        convenience init(presenter: UIViewController, navigationController: UINavigationController) {
            self.init(navigationController: navigationController)
            self.presenter = presenter
        }

        func start() {
            let vc = HomeViewController()
            vc.coordinator = self
            presenter?.present(vc, animated: true)
        }
}
