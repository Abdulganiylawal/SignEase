import Foundation
import StreamChat
import StreamChatSwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFunctions
import FirebaseFunctionsCombineSwift

@MainActor
final class MessageDataManager: ObservableObject {
    func addMessage(text: String) {
        message.append(Message(text: text))
    }
}

struct Message: Hashable {
    var text: String = ""
}

var message:[Message] = [
    
]

class ChatManager {
    static let shared = ChatManager()
    private let chatClient: ChatClient
    
    private init() {
        let config = ChatClientConfig(apiKey: .init("3n2z86vjm8wc"))
        chatClient = ChatClient(config: config)
    }
    
    func connectUser(userId: String, username: String, photoURL: String) {
        let functions = Functions.functions()
        functions.httpsCallable("ext-auth-chat-getStreamUserToken").call { [weak self] result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let token = result?.data as? String else {
                print("Invalid response data")
                return
            }
            let streamToken = try! Token(rawValue: token)
            
            
            self?.chatClient.connectUser(userInfo: .init(id: userId, name: username, imageURL:URL(string: photoURL)), token: streamToken) { error in
                if let error = error {
                    print("Connecting the user failed: \(error)")
                    return
                }
                print("User connected successfully!")
            }
        }
    }
    func createChannelWithFriend(username: String, photourl: String, friendUserId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let str = username
        let usermame = String(str.dropFirst())
        
        print(usermame)
        
        do {
            let channelController = try chatClient.channelController(createDirectMessageChannelWith: [friendUserId],
                isCurrentUserMember: true,
                name: username,
                imageURL: URL(string: photourl),
                extraData: [:])
            
            channelController.synchronize { error in
                if let error = error {
                    print("Failed to create channel: \(error)")
                    completion(.failure(error))
                } else {
                    print("Channel created successfully!")
                    completion(.success(()))
                }
            }
        } catch {
            print("Error creating channel: \(error)")
            completion(.failure(error))
        }
    }
    
    func sendMessage(message: String, cid: ChannelId) {
        let channelController = chatClient.channelController(for: cid)
        channelController.createNewMessage(text: message) { result in
            switch result {
            case .success(let messageId):
                print("Message sent with ID: \(messageId)")
//                self.getMessage(messageId: messageId, channelId: cid)
                let indices = channelController.messages.indices
                for i in indices{
                    print("\(channelController.messages[i].author.id): \(channelController.messages[i].text)")
                }
            case .failure(let error):
                print("Error sending message: \(error)")
            }
        }
    }

    func getMessage(messageId:MessageId,channelId:ChannelId){
        let messageController = chatClient.messageController(cid: channelId, messageId: messageId)
        messageController.synchronize { error in
           
            print(error ?? messageController.message!.text)
        }
    }
}

