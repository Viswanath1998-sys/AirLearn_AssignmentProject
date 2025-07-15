//
//  GitHubUserDetailsModel.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import Foundation


// MARK: - Welcome
struct UserDetails: Codable{
    let id: Int?
    let userName: String?
    let avatarURL: String?
    let reposURL: String?
    let bio: String?
    let publicRepos, followers: Int? // , following
    var repositories: [ReposDetails] = []
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "login"
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
        case bio
        case publicRepos = "public_repos"
        case followers
    }
}


struct ReposDetails: Codable{
    var id: Int?
    var name: String?
    var description: String?
    var forksCount: Int?
    var starsCount: Int?
    var following: Int?
    var repoLink: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case forksCount = "forks_count"
        case starsCount = "stargazers_count"
        case following
        case repoLink = "html_url"
    }
}











