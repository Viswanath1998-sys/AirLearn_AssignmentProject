//
//  Entitty+Extensions.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 15/07/25.
//

import Foundation


extension GitHubUsersEntity{
    func toUsers() -> GitHubUsers{
        GitHubUsers(userName: self.userName, id: Int(self.id), avatarURL: self.avatarURL, profileURL: self.profileURL, reposURL: self.reposURL, isBookMarked: self.isBookmarked)
    }
    
    func updateFrom(for user: GitHubUsers){
        self.id = Int32(user.id ?? 0)
        self.userName = user.userName
        self.avatarURL = user.avatarURL
        self.profileURL = user.profileURL
        self.reposURL = user.reposURL
        self.isBookmarked = user.isBookMarked
    }
    
}

extension UserDetailsEntity{

    func toUserDetails() -> UserDetails{
        let repoEntities = self.repositories as? Set<RepositoriesEntity> ?? []
        let repos = repoEntities.map { $0.toRepository() }
        return UserDetails(id: Int(self.id ), userName: self.userName, avatarURL: self.avatar,  reposURL: self.reposURL, bio: self.bio, publicRepos: Int(self.publicRepos), followers: Int(self.numberOfFollowers), repositories: repos)
    }
    
    func updateFrom(for user: UserDetails){
        let context = CoreDataStack.shared.context
        self.id = Int32(user.id ?? 0)
        self.userName = user.userName
        self.avatar = user.avatarURL
//        self.profileURL = user.profileURL
        self.bio = user.bio
        self.reposURL = user.reposURL
        self.publicRepos = Int16(user.publicRepos ?? 0)
        self.numberOfFollowers = Int16(user.followers ?? 0)
        
        // Delete existing child entities
               if let existingRepos = self.repositories as? Set<RepositoriesEntity> {
                   for repo in existingRepos {
                       context.delete(repo)
                   }
               }

               // Add new repositories
               for repoModel in user.repositories {
                   let repoEntity = RepositoriesEntity(context:context)
                   repoEntity.updateFrom(for: repoModel)
                   repoEntity.owner = self // set inverse relationship
               }
    }
}

extension RepositoriesEntity {
    func toRepository() -> ReposDetails {
       return ReposDetails(id: Int(self.id), name: self.repoName, description: self.repoDescription, forksCount: Int(self.forksCount), starsCount: Int(self.starsCount), repoLink: self.repoLink)
    }

    func updateFrom(for repo: ReposDetails) {
        self.id = Int32(repo.id ?? 0)
        self.repoName = repo.name
        self.repoDescription = repo.description
        self.forksCount = Int16(repo.forksCount ?? 0)
        self.starsCount = Int16(repo.starsCount ?? 0)
        self.repoLink = repo.repoLink
        
    }
}
