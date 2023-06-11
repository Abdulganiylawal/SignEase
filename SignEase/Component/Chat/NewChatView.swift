import SwiftUI
import StreamChat
import StreamChatSwiftUI

@available(iOS 16.0, *)
struct NewChatView: View {

    @ObservedObject var friendsData = FriendsModal()
    @State private var friend: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var success: Bool = false
   
    var body: some View {
        NavigationView {
            VStack {
                if friend {
                    ProgressView()
                } else if friendsData.user.isEmpty {
                    Text("No friends found.")
                } else {
                    List {
                        ForEach(Array(friendsData.user), id: \.friendUserId) { friend in
                           
                                if let profileURLString = friend.friendProfileUrl,
                                   let profileURL = URL(string: profileURLString) {
                                    FriendsItemView(name: friend.friendName ?? "Default", Username: friend.friendUsername ?? "Default", frame: 40, padding: 0, url: profileURL).onTapGesture {
                                        Task {
                                            do {
                                                ChatManager.shared.createChannelWithFriend(username: friend.friendUsername!, photourl: profileURLString, friendUserId: friend.friendUserId ?? "") { result in
                                                    switch result {
                                                    case .success:
                                                        success = true
                                                    case .failure(let error):
                                                        
                                                        print("Error: \(error.localizedDescription)")
                                                        success = false
                                                    }
                                                  
                                                }
                                            }
                                        }
                                    }

                                }
                            
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                    .environment(\.defaultMinListRowHeight, 50)
                }
            }
            .padding(.top, 16)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    }
                }
            }
            .navigationBarTitle("New Chat", displayMode: .inline)
        }
        .onAppear {
            Task {
                do {
                    friend = true
                    try await friendsData.loadCurrentUser()
                    friend = false
                } catch {
                    print(error)
                }
            }
        } .alert(isPresented: $success) {
            Alert(title: Text("Channel Created"), message: Text("You are ready to message your friend"), dismissButton: .default(Text("OK"),action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}
