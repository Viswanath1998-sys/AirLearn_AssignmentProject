//
//  GitHubUsersModel.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import Foundation


struct GitHubUsers : Codable, Hashable{
    
    let userName : String?
    let id : Int?
    let avatarURL : String?
    let profileURL : String?
    let reposURL : String?
    var isBookMarked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case id = "id"
        case avatarURL = "avatar_url"
        case profileURL = "url"
        case reposURL = "repos_url"
    }

    
    func searchFilter(searchText: String) -> Bool{
        // search filter with Case insensitive
        let loweredSearchText = searchText.lowercased()
        return userName?.lowercased().contains(loweredSearchText) ?? false
    }
}






