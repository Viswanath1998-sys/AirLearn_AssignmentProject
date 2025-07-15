//
//  GitHubUserDetailsViewModel.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import Foundation

@MainActor
class GitHubUserDetailsViewModel: BaseObservableObject{
    @Published var userDetails: UserDetails?
    var viewState: UserDetailsViewCurrentState {
        if isLoading{
            return .loading
        }else if userDetails == nil{
            return .dataEmpty
        }else{
            return .hasData
        }
    }
    
    // pagination
    @Published var repositories: [ReposDetails] = []  // For pagination access
    private var currentPage = 1
    @Published var isPaginating = false
    private var canLoadMorePages = true
    private var currentUserName: String?
    
    
   
//    func loadUserDetailsAndRepos(userToShow: GitHubUsers) async {
//        isLoading = true
//
//        guard isInternetConnected else {
//            let fetchecUserDetails = LocalDataManager.shared.fetchUserDetails(for: userToShow.userName ?? "")
//            userDetails = fetchecUserDetails
//            return
//        }
//        let userResult = await NetworkSession.shared.fetch(url: userToShow.profileURL ?? "", response: UserDetails.self)
//        let reposResults = await NetworkSession.shared.fetch(url: userToShow.reposURL ?? "", response: [ReposDetails].self)
//
//        // User Details
//        switch userResult{
//        case .success(let userDet):
//            userDetails = userDet
//        case .failure(let error):
//            print(error)
//        }
//
//        // Repo Details
//        switch reposResults {
//        case .success(let reposList):
//
//            var fullDetails = userDetails
//            fullDetails?.repositories = reposList
//            if let userDetailsAndRepos = fullDetails{
//                UserProfileAndReposDataManager.shared.saveOrUpdateUserDetails(userDetailsAndRepos)
//            }
//
//            userDetails?.repositories = reposList
////            repos = reposList.sorted(by: {$0.following ?? 0 > $1.following ?? 0}) // sort repositories following folllowing count
//        case .failure(let failure):
//            print(failure)
//        }
//
//
//        defer{
//            let fetchecUserDetails = LocalDataManager.shared.fetchUserDetails(for: userToShow.userName ?? "")
//            userDetails = fetchecUserDetails
//
//            isLoading = false
//        }
//    }
    
    func loadUserDetailsAndRepos(userToShow: GitHubUsers) async {
        isLoading = true
        currentUserName = userToShow.userName
        currentPage = 1
        canLoadMorePages = true
        repositories = []

        guard isInternetConnected else {
            let fetchedUserDetails = LocalDataManager.shared.fetchUserDetails(for: userToShow.userName ?? "")
            userDetails = fetchedUserDetails
            isLoading = false
            return
        }

        let userResult = await NetworkSession.shared.fetch(url: userToShow.profileURL ?? "", response: UserDetails.self)
        let reposResults = await NetworkSession.shared.fetch(url: "\(userToShow.reposURL ?? "")?page=1&per_page=20", response: [ReposDetails].self) // given 20 repos per page

        // User Details
        switch userResult {
        case .success(let userDet):
            userDetails = userDet
        case .failure(let error):
            print(error)
        }

        // Repositories (Page 1)
        switch reposResults {
        case .success(let reposList):
            var fullDetails = userDetails
            fullDetails?.repositories = reposList

            if let userDetailsAndRepos = fullDetails {
                UserProfileAndReposDataManager.shared.saveOrUpdateUserDetails(userDetailsAndRepos)
            }

            userDetails?.repositories = reposList
            repositories = reposList

            if reposList.count < 20 {
                canLoadMorePages = false
            }

        case .failure(let error):
            print(error)
        }

        defer {
            let fetchedUserDetails = LocalDataManager.shared.fetchUserDetails(for: userToShow.userName ?? "")
            userDetails = fetchedUserDetails
            isLoading = false
        }
    }
    func loadMoreRepositoriesIfNeeded(currentRepo: ReposDetails) {
        guard !isPaginating,
              canLoadMorePages,
              let last = repositories.last,
              currentRepo.id == last.id,
              let userName = currentUserName,
              let baseURL = userDetails?.reposURL
        else {
            return
        }

        isPaginating = true
        currentPage += 1

        Task {
            let nextURL = "\(baseURL)?page=\(currentPage)&per_page=20"
            let result = await NetworkSession.shared.fetch(url: nextURL, response: [ReposDetails].self)

            DispatchQueue.main.async {
                switch result {
                case .success(let newRepos):
                    if newRepos.isEmpty {
                        self.canLoadMorePages = false
                    } else {
                        self.repositories.append(contentsOf: newRepos)
                        self.userDetails?.repositories = self.repositories

                        if let fullDetails = self.userDetails {
                            UserProfileAndReposDataManager.shared.saveOrUpdateUserDetails(fullDetails)
                        }
                    }

                case .failure(let error):
                    print("Pagination error: \(error)")
                }

                self.isPaginating = false
            }
        }
    }

}

