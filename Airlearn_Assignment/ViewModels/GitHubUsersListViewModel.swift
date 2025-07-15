//
//  GitHubUsersListViewModel.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import Foundation
import Combine

@MainActor
class GitHubUsersListViewModel: BaseObservableObject{
    @Published var users = [GitHubUsers]()
    @Published var filteredUsers = [GitHubUsers]()
    @Published var selectedUser: GitHubUsers?
    @Published var isNavigateToUserDetails = false
    @Published var searchText = ""
    private var hasAlreadyFetchedAllUsers = false

    
    @Published var page = 0
    var pageSize = 20 // 20 users per page
    var canLoadMorePages = true
    var isLoadingPage = false
    
    var viewState: ViewCurrentState {
        if isLoading{
            return .loading
        }else if users.isEmpty{
            return .dataEmpty
        }else if filteredUsers.isEmpty{
            return .searchEmpty
        }else {
            return .hasData
        }
    }
    
    // To cancel the current running subscriber
       private var cancellable: Set<AnyCancellable> = []
    
    
    override init(){
        super.init()
        Task { @MainActor in
              observeSearchChanges()
          }
    }
    
    private func observeSearchChanges(){
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.filterSearchResults(searchText: text)
            }
            .store(in: &cancellable)
    }

    
    func loadUsers(reset: Bool = true) async {
        if reset { // run initially
            page = 0
            canLoadMorePages = true
            users = []
            filteredUsers = []
        }

        guard canLoadMorePages else { return }

        isLoadingPage = true
        isLoading = reset

        let offset = page * pageSize

        var newUsers = [GitHubUsers]()

        // fi no data from coredata fetch API call when internet connected
        if isInternetConnected {
            let url = "https://api.github.com/users?since=\(users.last?.id ?? 0)&per_page=\(pageSize)"
            let result = await NetworkSession.shared.fetch(url: url, response: [GitHubUsers].self)

            switch result {
            case .success(let usersList):
                LocalDataManager.shared.saveGitHubUsers(users: usersList)

                newUsers = LocalDataManager.shared.fetchGitHubUsers(offset: offset, limit: pageSize) // fetch after saving
                loadDetailsAndReposInBackground(for: usersList)
            case .failure(let error):
                errorMessage = error.errorDescription
               
            }
        }else {
            newUsers = LocalDataManager.shared.fetchGitHubUsers(offset: offset, limit: pageSize)
        }

        if newUsers.count < pageSize {
            canLoadMorePages = false
        }

        self.users.append(contentsOf: newUsers)
        self.filterSearchResults(searchText: searchText)

        page += 1 // next page
        isLoading = false
        isLoadingPage = false
    }

    func getUsersToUI() async{
        await loadUsers()
        filterSearchResults(searchText: searchText)
    }
    
    
    func loadNextPageIfNeeded(currentUser user: GitHubUsers) {
        guard let lastUser = filteredUsers.last else { return }

        if user.id == lastUser.id && canLoadMorePages && !isLoadingPage {
            Task {
                await loadUsers(reset: false)
            }
        }
    }

    
    func filterSearchResults(searchText: String){
        if searchText.isEmpty{
            self.filteredUsers = self.users
        }else {
            // filter searchText matched list
            self.filteredUsers = users.filter({$0.searchFilter(searchText: searchText)})
        }
    }
    
    
    func loadDetailsAndReposInBackground(for users: [GitHubUsers]) {
        Task.detached(priority: .background) {
            await withTaskGroup(of: Void.self) { group in
                for user in users {
                    group.addTask {
                        async let userResult = NetworkSession.shared.fetch(url: user.profileURL ?? "", response: UserDetails.self)

                        async let reposResults = NetworkSession.shared.fetch(url: user.reposURL ?? "", response: [ReposDetails].self)

                        
                        do {
                            let (userDetailsResp, reposResp) = await (userResult, reposResults)
                            
                            if case .success(let userDetails) = userDetailsResp,
                               case .success(let repos) = reposResp {
                                var fullDetails = userDetails
                                fullDetails.repositories = repos
                                LocalDataManager.shared.saveOrUpdateUserDetails(fullDetails)
                            }
                        } catch {
                            print("Error loading details or repos for \(user.userName ?? ""): \(error)")
                        }
                    }
                }
            }
        }
    }
}



