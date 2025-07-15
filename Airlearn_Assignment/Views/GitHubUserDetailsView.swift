//
//  GitHubUserDetailsView.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import SwiftUI

struct GitHubUserDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = GitHubUserDetailsViewModel()
    var user: GitHubUsers
    
    init(userToShow: GitHubUsers){
        user = userToShow
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            handleCurrentViewStatus()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss() // Back to previous View
                } label: {
                    HStack{
                        Image(systemName: "arrow.left").resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                        Text("Back").font(.headline).foregroundStyle(Color.blue)
                    }
                }
            }
        }
        .task {
            await viewModel.loadUserDetailsAndRepos(userToShow: user)
        }
    }
    
    @ViewBuilder
    private func handleCurrentViewStatus() -> some View{
        switch viewModel.viewState {
        case .loading:
            CircularLoader()
            
        case .dataEmpty:
            EmptyStateView(emptyMessage: viewModel.errorMessage == nil ? "No Users found." : viewModel.errorMessage ?? "")
            
        case .hasData:
            Text("User Profile").font(.title2)
            // Avatar
            AvatarImageView(imageURL: viewModel.userDetails?.avatarURL ?? "", size: 120)
            
            // Username
            Text(viewModel.userDetails?.userName ?? "")
                .font(.title)
                .fontWeight(.bold)
            
            // Bio
            Text(viewModel.userDetails?.bio ?? "No Bio about user")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Stats
            HStack(spacing: 24) {
                VStack {
                    Text("\(viewModel.userDetails?.followers ?? 0)")
                        .font(.headline)
                    Text("Followers")
                        .font(.caption)
                }
                
                VStack {
                    Text("\(viewModel.userDetails?.publicRepos ?? 0)")
                        .font(.headline)
                    Text("Repos")
                        .font(.caption)
                }
            }
            
            // Repositories List
            if let repositories = viewModel.userDetails?.repositories, !repositories.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Repositories")
                        .font(.title2).frame(alignment: .center)
                    ScrollView{
                        LazyVStack(spacing: 16) {
                            ForEach(repositories, id: \.id) { repo in
                                RepositoryInfoView(repo: repo)
                                    .onAppear {
                                        // load repositories for pagination
                                        viewModel.loadMoreRepositoriesIfNeeded(currentRepo: repo)
                                    }
                            }
                        }
                        if viewModel.isPaginating {
                            ProgressView()
                                .padding()
                        }
                    }.refreshable {
                        await viewModel.loadUserDetailsAndRepos(userToShow: user)
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }
}

//struct GitHubUserDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GitHubUserDetailsView(userToShow: GitHubUsers())
//    }
//}




struct AvatarImageView: View {
    let imageURL: String?
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL ?? "")) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .shadow(radius: 8)
            case .failure:
                Image(systemName: "person.crop.circle.badge.exclamationmark")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
}



struct RepositoryInfoView: View {
    let repo: ReposDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(repo.name ?? "")
                .font(.headline)
            
            Text(repo.description ?? "No Description found")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                Text(" Stars Count: \(repo.starsCount ?? 0)")
                Text(" Forks Count: \(repo.forksCount ?? 0)")
                Spacer(minLength: 0)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            // Redirect to Repository
            if let url = URL(string: repo.repoLink ?? ""){
                Link("Explore Repository", destination: url)
            }
          
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
