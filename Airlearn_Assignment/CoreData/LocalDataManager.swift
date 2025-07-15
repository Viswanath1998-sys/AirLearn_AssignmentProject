//
//  LocalDataManager.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 15/07/25.
//

import Foundation


class LocalDataManager: DataManagerProtocol{
    
    static let shared = LocalDataManager()
    
    func saveGitHubUsers(users: [GitHubUsers]) {
        GitHubUsersDataManager.shared.saveGitHubUsers(users: users)
    }
    
    func fetchGitHubUsers(offset: Int, limit: Int) -> [GitHubUsers] {
        GitHubUsersDataManager.shared.fetchGitHubUsers(offset: offset, limit: limit)
    }
    
    func updateTask(_ user: GitHubUsers) {
        GitHubUsersDataManager.shared.updateTask(user)
    }
    
    func toggleBookMark(for userName: String) {
        GitHubUsersDataManager.shared.toggleBookMark(for: userName)
    }
    
    func saveOrUpdateUserDetails(_ user: UserDetails) {
        UserProfileAndReposDataManager.shared.saveOrUpdateUserDetails(user)
    }
    
     func fetchUserDetails(for userName: String) -> UserDetails? {
        UserProfileAndReposDataManager.shared.fetchUserDetails(for: userName)
    }
    
    
}




protocol DataManagerProtocol{
    func saveGitHubUsers(users: [GitHubUsers])
    func fetchGitHubUsers(offset: Int, limit: Int) -> [GitHubUsers]
    func updateTask(_ user: GitHubUsers)
    func toggleBookMark(for userName: String)
    func saveOrUpdateUserDetails(_ user: UserDetails)
    func fetchUserDetails(for userName: String) -> UserDetails?
}
