
import SwiftUI

struct ChatBubble: View {
    @State var message: MessageData = MessageData(text: "")
    var body: some View {
        if(message.isMe == true)
        {
            VStack(alignment: .trailing, spacing: 0) {
                UserBubble(content: message.text,timeStamp: message.timeStamp)
                    .padding(.leading, 40)
                    .padding(.trailing, 10)
            }
        }
        else {
            VStack(alignment: .leading, spacing: 0) {
                NotUserBubble(content: message.text,timeStamp: message.timeStamp)
                    .padding(.trailing, 40)
                    .padding(.leading, 10)
            }
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble()
    }
}
