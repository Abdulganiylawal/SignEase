import SwiftUI
import StreamChat
import StreamChatSwiftUI
import Foundation


import SwiftUI

@available(iOS 16.0, *)
class ConversationView: ViewFactory {
    @Injected(\.chatClient) var chatClient: ChatClient
    
    func makeChannelListHeaderViewModifier(title: String) -> ConvesationHeaderViewModifier {
        ConvesationHeaderViewModifier(title: "")
    }
    
    func makeChannelListItem(channel: ChatChannel, channelName: String, avatar: URL, onlineIndicatorShown: Bool, disabled: Bool, selectedChannel: Binding<ChannelSelectionInfo?>, swipedChannelId: Binding<String?>, channelDestination: @escaping (ChannelSelectionInfo) -> ChatChannelView<ConversationView>, onItemTap: @escaping (ChatChannel) -> Void, trailingSwipeRightButtonTapped: @escaping (ChatChannel) -> Void, trailingSwipeLeftButtonTapped: @escaping (ChatChannel) -> Void, leadingSwipeButtonTapped: @escaping (ChatChannel) -> Void) -> some View {
        ConversationListItems(channel: channel, conversationName: channelName, avatar: avatar, channelDestination: channelDestination, selectedChannel: selectedChannel, onItemTap: onItemTap)
    }
}


