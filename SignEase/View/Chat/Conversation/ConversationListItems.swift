
import SwiftUI
import StreamChat
import StreamChatSwiftUI
@available(iOS 16.0, *)
struct ConversationListItems: View {
        let channel: ChatChannel
        let conversationName: String
        let avatar: URL
        let channelDestination: (ChannelSelectionInfo) -> ChatChannelView<ConversationView>
        @Binding var selectedChannel: ChannelSelectionInfo?
        let onItemTap: (ChatChannel) -> Void
    var body: some View {
        ZStack {
                ConversationListItemsView(
                    ConversationName: channel.name!,
                    avatar: avatar,
                    lastMessageAt: channel.lastMessageAt ?? Date(),
                    hasUnreadMessages: channel.unreadCount.messages > 0,
                    lastMessage: channel.latestMessages.first?.text ?? "No messages",
                    isMuted: channel.isMuted
                )
                    .padding(.trailing)
                    .onTapGesture {
                        onItemTap(channel)
                    }
                
                NavigationLink(tag: channel.channelSelectionInfo, selection: $selectedChannel) {
                    
                    channelDestination(channel.channelSelectionInfo)
                } label: {
                    EmptyView()
                }
            }
    }
}

