//
//  FriendsView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 19/05/2023.
//

import SwiftUI

struct FriendsView: View {
    @StateObject var friendsData = FriendsModal()
    @State var friend:Bool = false
    var body: some View {
        HStack {
            if friend == true {
                ProgressView()
            } else if friendsData.user.isEmpty {
                Text("No friends found.")
            } else {
                List {
                    ForEach(Array(friendsData.user), id: \.friendUserId) { friend in
                        if let profileURLString = friend.friendProfileUrl,
                           let profileURL = URL(string: profileURLString) {
                            FriendsItemView(name: friend.friendName ?? "Default", Username: friend.friendUsername ?? "Default", url: profileURL)
                        }
                    }
                    
                }.navigationTitle("Friends")
                    .navigationBarTitleDisplayMode(.inline)
                    .listStyle(.insetGrouped)
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                    .environment(\.defaultMinListRowHeight, 50)
            }
        }
        .onAppear {
            Task {
                do {
                    self.friend = true
                    try await friendsData.loadCurrentUser()
                    self.friend = false
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
