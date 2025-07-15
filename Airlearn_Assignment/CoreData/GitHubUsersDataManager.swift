//
//  GitHubUsersDataManager.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 15/07/25.
//

import Foundation
import CoreData

class GitHubUsersDataManager{
    static let shared = GitHubUsersDataManager()
    private let context = CoreDataStack.shared.context
    
    func saveGitHubUsers(users: [GitHubUsers]) {
        users.forEach{ user in
            let fetchRequest: NSFetchRequest<GitHubUsersEntity> = GitHubUsersEntity.fetchRequest()
           
            fetchRequest.predicate = NSPredicate(format: "userName == %@", user.userName ?? "")
           
            if let existing = try? context.fetch(fetchRequest).first {
                // Update existing
                existing.userName = user.userName
                existing.avatarURL = user.avatarURL
            } else {
                
                let entity = GitHubUsersEntity(context: context)
                entity.updateFrom(for: user)
            }
        }
        
        saveContext()
    }
        
    
    func fetchGitHubUsers(offset: Int = 0, limit: Int = 20) -> [GitHubUsers] {
        let fetchRequest: NSFetchRequest<GitHubUsersEntity> = GitHubUsersEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit

        do {
            let result = try context.fetch(fetchRequest)
            return result.map { $0.toUsers() }
        } catch {
            print("Paginated fetch failed: \(error)")
            return []
        }
    }


    func updateTask(_ user: GitHubUsers) {
        let request: NSFetchRequest<GitHubUsersEntity> = GitHubUsersEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userName == %@", user.userName ?? "")
        
        do {
            if let entity = try context.fetch(request).first {
                entity.updateFrom(for: user)
                saveContext()
                print("Task successfully updated")
            }
        } catch {
            print("Task Update error: \(error.localizedDescription)")
        }
    }
    
    func toggleBookMark(for userName: String){
        let fetchRequest: NSFetchRequest<GitHubUsersEntity> = GitHubUsersEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userName == %@", userName)
        if let user = try? context.fetch(fetchRequest).first {
            user.isBookmarked.toggle()
            saveContext()
            print("BookMark Toggle changed...")
        }
    }
    
    
    // MARK: - save context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Core Data Save Error: \(error.localizedDescription)")
        }
    }
}
