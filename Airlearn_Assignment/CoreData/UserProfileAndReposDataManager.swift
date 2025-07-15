//
//  UserProfileAndReposDataManager.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 15/07/25.
//

import Foundation
import CoreData


class UserProfileAndReposDataManager{
    let context = CoreDataStack.shared.context
    static let shared = UserProfileAndReposDataManager()
    
    // save new one update existing one
    func saveOrUpdateUserDetails(_ user: UserDetails) {
        context.perform { [self] in
            let request: NSFetchRequest<UserDetailsEntity> = UserDetailsEntity.fetchRequest()
            request.predicate = NSPredicate(format: "userName == %@", user.userName ?? "")

            let userEntity = (try? context.fetch(request).first) ?? UserDetailsEntity(context: self.context)
            userEntity.updateFrom(for: user)

            do {
                try context.save()
            } catch {
                print("Failed to save user details: \(error)")
            }
        }
    }

    
    func fetchUserDetails(for userName: String) -> UserDetails? {
        let request: NSFetchRequest<UserDetailsEntity> = UserDetailsEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userName == %@", userName)

        do {
            if let entity = try context.fetch(request).first {
                return entity.toUserDetails()
            } else {
                print("UserDetails not found for: \(userName)")
                return nil
            }
        } catch {
            print("Failed to fetch UserDetails: \(error)")
            return nil
        }
    }
}
