import SwiftUI

struct ChatView: View {
    @State private var showNewChatView = false
    @StateObject private var profileData = ProfileModal()
    @StateObject private var viewModel = ChatListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(viewModel.chatListItems) { chatItem in
                    Section {
                        if let username = chatItem.userName,let url = chatItem.url {
                            chatItems(userName: username,url: URL(string: url))
                        } else {
                            chatItems()
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewChatView.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showNewChatView) {
                NewChatView()
            }
            .onAppear {
                Task {
                    do {
//                        viewModel.populateChatListItems()
                        try await profileData.loadCurrentUser()
                    } catch {
                        print("Error loading current user: \(error)")
                    }
                }
            }
        }
    }
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
