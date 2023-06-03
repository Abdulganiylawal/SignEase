import SwiftUI
import StreamChat
import StreamChatSwiftUI
import UIKit

@available(iOS 16.0, *)
struct TextMessageField: View {
    @State var message: String = ""
    @ObservedObject var MessageData: MessageDataManager
    var channel: ChatChannel
    var body: some View {
        HStack {
            TextField("Enter Message", text: $message,axis:.vertical)
                .disableAutocorrection(true)
                .padding(10)
                .disabled(true)
            Button(action: {
                if (message != ""){
                    MessageData.sendMessage(message: message, cid: channel.cid )
                    DetectedObjectModal.shared.recognizedObjects = ""
                }
            }){
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width:20, height:20)
                    .padding(.trailing, 15)
            }
            Button(action: {
                _ = DetectedObjectModal.shared.recognizedObjects.popLast()
                
            }){
                Image(systemName: "delete.backward.fill")
                    .resizable()
                    .frame(width:20, height:20)
                    .padding(.trailing, 15)
            }.simultaneousGesture(
                LongPressGesture(minimumDuration: 1.2)
                    .onEnded { _ in
                        DetectedObjectModal.shared.recognizedObjects = ""
                    }
            )
        }.onReceive(DetectedObjectModal.shared.$recognizedObjects, perform: { text in
            message = text
        })
        .onDisappear(perform: {
            DetectedObjectModal.shared.recognizedObjects = ""
        })
        .foregroundColor(Color.gray)
        .overlay(RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray, lineWidth: 1)
            .shadow(radius: 20))
    }
}
