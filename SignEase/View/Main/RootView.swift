
import SwiftUI
import StreamChat
import StreamChatSwiftUI

@available(iOS 16.0, *)
struct RootView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .account
    @ObservedObject private var profileData = ProfileModal()
    @State var showNewChat:Bool = false
    var body: some View {
        ZStack{
            Group {
                switch selectedTab {
                case .chat:
                    Conversation
                case .account:
                    AccountView()
                }
                
            }
            TabBar()
        }
    }
    
    var Conversation:  some View{
      
        ChatChannelListView(viewFactory: ConversationView()).navigationTitle("Chats").toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showNewChat.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                    
                }.sheet(isPresented: $showNewChat) {
                    NewChatView()
                }
            }
        }
    }
}


