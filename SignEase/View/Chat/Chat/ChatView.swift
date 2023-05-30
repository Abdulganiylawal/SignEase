import SwiftUI
import StreamChat
import StreamChatSwiftUI
import Combine

struct ChatView: View {
    @State var messageArray = message
    @State var Count: Int? = nil
    @StateObject var messageData:MessageDataManager = MessageDataManager()
    var channel: ChatChannel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ForEach(messageData.message!,id: \.id) { message in
                    ChatBubble(message: message)
                }
                .flip()
            }
            .flip()
            Divider()
                .padding(.top, 50)
                .padding(.bottom, 10)
            
            TextMessageField( MessageData: messageData, channel: channel)
                .frame(alignment: .center)
                .padding(5)
        }.toolbar {
            ToolbarItem(placement: .principal) {
                TitleRow(imageUrl: channel.imageURL, name: channel.name!)
            }
        }.onAppear {
           messageData.loadMessages(cid: channel.cid)
                          
        }.onDisappear{
            messageData.setMessage()
        }
        .onChange(of: messageData.message?.count) { newValue in
            messageData.loadMessages(cid: channel.cid)
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
