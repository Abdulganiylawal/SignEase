
import StreamChat
import StreamChatSwiftUI
import SwiftUI

@available(iOS 16.0, *)
struct CommunicatorView: View {
    let channel: ChatChannel
    var body: some View {
        VStack{
            CameraView()
            ChatView(channel: channel)
        }
    }
}

