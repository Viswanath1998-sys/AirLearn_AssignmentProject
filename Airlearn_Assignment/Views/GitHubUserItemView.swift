//
//  GitHubUserItemView.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import SwiftUI

struct GitHubUserItemView: View {
    @ObservedObject var viewModel : GitHubUsersListViewModel
    var user: GitHubUsers

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 16) {
                AvatarImageView(imageURL: user.avatarURL ?? "", size: 100)

                Text(user.userName ?? "")
                    .font(.title2)

                Spacer(minLength: 0)
            }
            .padding()

            // Bookmark/Favorite button
            Button {
                if let index = viewModel.filteredUsers.firstIndex(where: { $0.userName == user.userName }) {
                    viewModel.filteredUsers[index].isBookMarked.toggle()
                }

                LocalDataManager.shared.toggleBookMark(for: user.userName ?? "")
            } label: {
                Image(systemName: user.isBookMarked ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .foregroundColor(user.isBookMarked ? .yellow : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [Color.green.opacity(0.3), Color.blue.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.blue.opacity(0.1), radius: 16, x: 0, y: 3)
        )
        .padding(.horizontal)
    }
}

//struct GitHubUserItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        GitHubUserItemView(user: GitHubUsers())
//    }
//}
