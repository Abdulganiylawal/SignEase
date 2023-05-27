////
////  ChatBubble.swift
////  SignEase
////
////  Created by Lawal Abdulganiy on 27/05/2023.
////
//
import SwiftUI

struct ChatBubble: View {
    @State var message: Message = Message(text: "")
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            UserBubble(content: message.text)
                    .padding(.leading, 40)
                    .padding(.trailing, 10)
            }
        
//        else {
//            VStack(alignment: .leading, spacing: 0) {
//                NotUserBubble(color: user.color, content: message.content, timeStamp: message.timeStamp, username: user.name)
//                    .padding(.trailing, 40)
//                    .padding(.leading, 10)
//            }
//        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble()
    }
}
