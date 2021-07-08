//
//  HomeViewController.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-06-26.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    
    weak var coordinator: Coordinator?
    
    var user: String? {
        didSet {
            nameLabel.text = user 
        }
    }
    
    var login: String? {
        didSet {
            loginLabel.text = login
        }
    }
    
    var userViewModel: UserViewModel?
    



    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userViewModel?.userFetchCompletion = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.user = strongSelf.userViewModel?.getUsername()
            strongSelf.login = strongSelf.userViewModel?.getLogin()
        }
        userViewModel?.start()
        setupUI()
  
    }
    
    func setupUI() {
        
        viewContainer.layer.cornerRadius = 8
        viewContainer.backgroundColor = .lightGray
        viewContainer.layer.borderColor = UIColor.white.cgColor
        viewContainer.layer.borderWidth = 1
        viewContainer.backgroundColor = .black
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.backgroundColor = .darkGray
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 1

    }


}
