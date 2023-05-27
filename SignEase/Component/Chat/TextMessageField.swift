import SwiftUI
import StreamChat
import StreamChatSwiftUI
struct TextMessageField: View {
    @Binding var currentMessageContent: String
    @Binding var messages: [Message]
    var channel: ChatChannel
    
    var body: some View {
        HStack {
            TextField("Enter Message", text: $currentMessageContent)
                .disableAutocorrection(true)
                .padding(10)
               
            Button(action: {
                if (currentMessageContent != ""){
                    messages.append(Message(text: currentMessageContent))
                    ChatManager.shared.sendMessage(message: currentMessageContent, cid: channel.cid )
                    currentMessageContent = ""
                    
                }
            }){
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width:20, height:20)
                    .padding(.trailing, 15)
            }

        }
        .foregroundColor(Color.gray)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
                    .shadow(radius: 20))
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
