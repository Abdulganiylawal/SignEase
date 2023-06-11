import SwiftUI
import StreamChat
import StreamChatSwiftUI


@available(iOS 16.0, *)
class ConversationView: ViewFactory {
    @Injected(\.chatClient) var chatClient: ChatClient
    @AppStorage("ChatViewSelection") var selectedView = "Standard"
    public init() {}
    public static let shared = ConversationView()
 
    func makeChannelListHeaderViewModifier(title: String) -> ConvesationHeaderViewModifier {
        ConvesationHeaderViewModifier(title: "")
    }
    
    func makeChannelDestination() -> (ChannelSelectionInfo) -> AnyView {
        switch selectedView {
        case "Standard":
            return { selectionInfo in
                let channelIdString = selectionInfo.channel.cid.rawValue
                return AnyView(ChatChannelView(viewFactory: ConversationView.shared, channelController: self.chatClient.channelController(
                    for: try! ChannelId(cid: channelIdString),
                    messageOrdering: .topToBottom
                )))
            }
        case "SignLanguageChatView":
            return { selectionInfo in
                return AnyView(CommunicatorView(channel: selectionInfo.channel))
            }
        default:
            return { _ in
                return AnyView(EmptyView())
            }
        }
    }



    func makeChannelListItem(channel: ChatChannel, channelName: String, avatar: URL, onlineIndicatorShown: Bool, disabled: Bool, selectedChannel: Binding<ChannelSelectionInfo?>, swipedChannelId: Binding<String?>, channelDestination: @escaping (ChannelSelectionInfo) -> ChatChannelView<ConversationView>, onItemTap: @escaping (ChatChannel) -> Void, trailingSwipeRightButtonTapped: @escaping (ChatChannel) -> Void, trailingSwipeLeftButtonTapped: @escaping (ChatChannel) -> Void, leadingSwipeButtonTapped: @escaping (ChatChannel) -> Void) -> some View {
        ConversationListItems(channel: channel, conversationName: channelName, avatar: avatar, channelDestination: channelDestination, selectedChannel: selectedChannel, onItemTap: onItemTap)
    }
    
}

