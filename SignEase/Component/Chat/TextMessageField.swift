import SwiftUI
import StreamChat
import StreamChatSwiftUI
import UIKit

@available(iOS 16.0, *)
struct TextMessageField: View {
    @State var message: String = ""
    @ObservedObject var MessageData: MessageDataManager
    @State private var currentObject: String = ""
    @State private var recognizedObjects: Set<String> = []
    var channel: ChatChannel
    var body: some View {
        HStack {
            TextField("Enter Message", text: $message,axis:.vertical)
                .disableAutocorrection(true)
                .padding(10)
                .disabled(true)
            Button(action: {
                message += " "
            })  {
                Image(systemName: "space")
                    .resizable()
                    .foregroundColor(.cyan)
                    .frame(width:20, height:20)
                    .padding(.trailing, 15)
            }
            Button(action: {
                if (message != ""){
                    MessageData.sendMessage(message: message, cid: channel.cid )
                    message = ""
                    currentObject = ""
                }
            }){
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width:20, height:20)
                    .padding(.trailing, 15)
            }
           
            Button(action: {
                _ = message.popLast()
            }){
                Image(systemName: "delete.backward.fill")
                    .resizable()
                    .frame(width:20, height:20)
                    .padding(.trailing, 15)
            }.simultaneousGesture(
                LongPressGesture(minimumDuration: 1.2)
                    .onEnded { _ in
                        message = ""
                        currentObject = ""
                    }
            )
        }.onReceive(DetectedObjectModal.shared.$recognizedObjects, perform: { newObjects in
            if newObjects == [""] {
                ResetRecognition()
            }
            else{
                recognizedObjects = Set(newObjects)
                let value = Array(recognizedObjects).joined(separator: "")
                if !currentObject.contains(value){
                    currentObject += value
                        message += currentObject
                }
            }
        })
        .onDisappear(perform: {
            DetectedObjectModal.shared.recognizedObjects = []
        })
        .foregroundColor(Color.gray)
        .overlay(RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray, lineWidth: 1)
            .shadow(radius: 20))
    }
    
    private func ResetRecognition(){
        recognizedObjects = Set<String>()
        currentObject = ""
    }
}
