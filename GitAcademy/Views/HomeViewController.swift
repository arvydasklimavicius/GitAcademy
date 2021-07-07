//
//  HomeViewController.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-06-26.
//

import UIKit

class HomeViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    
    var user: String? = ""
    var login: String? = ""
    



    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
  
    }
    
    func setupUI() {
        
        viewContainer.layer.cornerRadius = 8
        viewContainer.backgroundColor = .lightGray
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.backgroundColor = .red
        nameLabel.text = user
        loginLabel.text = login
        
    }


}
