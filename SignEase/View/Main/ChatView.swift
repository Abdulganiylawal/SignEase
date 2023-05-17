import SwiftUI

struct ChatView: View {
    @State private var showNewChatView = false
    @StateObject private var profileData = ProfileModal()
    @StateObject private var viewModel = ChatListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.chatListItems,id: \.id) { chatItem in
                        if let username = chatItem.userName,let url = chatItem.url {
                            chatItems(userName: username,url: URL(string: url))
                        } else {
                            chatItems()
                        }
                }
                .listRowSeparator(.hidden)
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
                   ChatListViewModel()
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
