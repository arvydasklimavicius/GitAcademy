//
//  User.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-07-01.
//

import Foundation

struct User: Codable {
    var login: String
    var name: String
    var avatarURL: String
    var followers: Int
    var following: Int
    var publicRepos: Int
    
    enum CodingKeys: String, CodingKey {
        case login
        case name
        case followers
        case following
        case avatarURL = "avatar_url"
        case publicRepos = "public_repos"
    }
}
