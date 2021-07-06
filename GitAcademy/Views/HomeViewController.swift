//
//  HomeViewController.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-06-26.
//

import UIKit

class HomeViewController: UIViewController {
    
    var user: String? = ""
    

    @IBOutlet weak var nameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user

        

        
    }


}
