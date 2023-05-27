import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct ChatView: View {
    @State private var newMessageText = ""
    @State var messageDataManager = message
    var channel: ChatChannel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ForEach(messageDataManager,id: \.self) { message in
                    ChatBubble(message: message)
                }
                .flip()
            }
            .flip()
            
            Divider()
                .padding(.top, 50)
                .padding(.bottom, 10)
            
            TextMessageField(currentMessageContent: $newMessageText, messages: $messageDataManager, channel: channel)
                .frame(alignment: .center)
                .padding(5)
        }.toolbar {
            ToolbarItem(placement: .principal) {
                TitleRow(imageUrl: channel.imageURL, name: channel.name!)
            }
        }
    }
}


extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
