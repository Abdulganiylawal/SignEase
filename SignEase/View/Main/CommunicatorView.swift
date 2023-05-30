
import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct CommunicatorView: View {
    let channel: ChatChannel
    var body: some View {
        VStack{
            CameraView()
            ChatView(channel: channel)
        }
    }
}

