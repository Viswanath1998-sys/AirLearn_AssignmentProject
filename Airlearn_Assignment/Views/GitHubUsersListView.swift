//
//  GitHubUsersListView.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import SwiftUI


struct GitHubUsersListView: View {
    @StateObject private var viewModel = GitHubUsersListViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
            ZStack{
                LinearGradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                VStack{
                    handleCurrentViewStatus()
                }
            }.navigationBarBackButtonHidden(true)
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
               await viewModel.getUsersToUI()
            }
            .searchable(text: $viewModel.searchText)

        }
    
    @ViewBuilder
    private func handleCurrentViewStatus() -> some View{
        switch viewModel.viewState {
          case .loading:
              CircularLoader()
              
          case .dataEmpty:
                  EmptyStateView(emptyMessage: viewModel.errorMessage == nil ? "No Users found." : viewModel.errorMessage ?? "")
              
          case .searchEmpty:
              EmptyStateView(emptyMessage: "User not found for your search.")
              
          case .hasData:
            ScrollView{
                  LazyVStack(spacing: 16){
                      ForEach(viewModel.filteredUsers, id: \.id) { user in
                          NavigationLink(destination: GitHubUserDetailsView(userToShow: user)) {
                              GitHubUserItemView(viewModel: viewModel, user: user)
                                  .onAppear {
                                      viewModel.loadNextPageIfNeeded(currentUser: user)
                                  }
                          }

                      }
                  }
            }
            .refreshable {
                await viewModel.getUsersToUI()
            }
          }
      }
}

struct GitHubUsersListView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubUsersListView()
    }
}
