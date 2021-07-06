//
//  LoginManager.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-06-22.
//

import UIKit

class GitHubAPI {
    
    static let accessTokenURL = "https://github.com/login/oauth/access_token"
    static let authorizationURL = "https://github.com/login/oauth/authorize"
    
    static let clientSecret = "bddfbb1d25c9ace4fde2c5efee69c194ec5706ca"
    static let redirectUri = "project://oauth"
    static let clientId = "Iv1.d99a131f3360451f"
    static let scope = "read:user,user:email"
    
    
}
