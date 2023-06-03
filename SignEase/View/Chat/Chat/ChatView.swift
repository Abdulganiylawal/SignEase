import SwiftUI
import StreamChat
import StreamChatSwiftUI
import Combine

@available(iOS 16.0, *)
struct ChatView: View {
    @StateObject var messageData: MessageDataManager = MessageDataManager()
    @State var isTriggered = false
    @State var authUser: String = ""
    @State private var scrollToBottom = false

    var channel: ChatChannel
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(messageData.message!, id: \.id) { message in
                            ChatBubble(message: message)
                        }.flip()
                            .flip()
                        .onChange(of: messageData.message) { _ in
                            scrollToBottom = true
                        }
                    }
                    VStack(spacing: 8) {
                        ForEach(messageData.receivedMessages!, id: \.id) { message in
                            if message.usersId != authUser {
                                ChatBubble(message: message)
                            }
                        }.flip()
                        .flip()
                        .id(isTriggered)
                    }
                }
                .flip()
                .flip()
            }
            Divider()
                .padding(.top, 50)
                .padding(.bottom, 10)
            
            TextMessageField(MessageData: messageData, channel: channel)
                .frame(alignment: .center)
                .padding(5)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                TitleRow(imageUrl: channel.imageURL, name: channel.name!)
            }
        }
        .onAppear {
            messageData.loadMessages(cid: channel.cid)
            NotificationCenter.default.addObserver(forName: .isTriggeredChange, object: nil, queue: .main) { _ in
                isTriggered = true
            }
            authUser = try! Authentication.shared.getAuthUser().uid
        }
        .onDisappear {
            messageData.setMessage()
        } 
        .onChange(of: isTriggered) { newValue in
            if newValue {
                messageData.getRecieversMessages()
                isTriggered = false
            }
        }
    }
}


extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .bottom)
    }
}
