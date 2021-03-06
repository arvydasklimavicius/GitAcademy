//
//  Coordinator.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-07.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

class Coordinator {
    
    func start() {
        let vc = HomeViewController()
        vc.coordinator = self
    }
    
    func startHomeViewController(rootVC: UIViewController) {
        let vc = HomeViewController.instantiate()
        let userViewModel = UserViewModel()
        vc.userViewModel = userViewModel
        vc.modalPresentationStyle = .fullScreen
        rootVC.present(vc, animated: true, completion: nil)
    }
    
    func startRepositoriesViewController() {
        
    }
    
}

//MARK: - Coordinator extension for storyboards

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        
        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

