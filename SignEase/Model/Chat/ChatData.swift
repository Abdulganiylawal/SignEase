import Foundation
import StreamChat
import StreamChatSwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFunctions
import FirebaseFunctionsCombineSwift


final class MessageDataManager: ObservableObject {
    @Published private(set) var message: [Message]? = []
    @Published private(set) var count: Int?
    
    func loadMessages(cid: ChannelId?){
        message = ChatManager.shared.loadMessages(cid: cid)
//        message!.sort {$0.CreatedAt < $1.CreatedAt}
//        print(message?.count)
    }
    func setMessage(){
        self.message = []
//        print(message?.count)
    }
    
    func sendMessage(message: String, cid: ChannelId){
        ChatManager.shared.sendMessage(message: message, cid: cid)
        self.message!.append(Message(text: message, isMe: true))
    }

}

struct Message:Hashable {
    var id = UUID()
    var text: String = ""
    var isMe:Bool = true
    var timeStamp: String = ""
    var CreatedAt:Date = Date()
}

var message: [Message] = []


class ChatManager {
    static let shared = ChatManager()
    private let chatClient: ChatClient
    let MessageData = MessageDataManager()
    
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
            case .failure(let error):
                print("Error sending message: \(error)")
            }
        }
        channelController.synchronize{
            error in
            print(error )
        }
    }
    
    func getMessage(messageId:MessageId,channelId:ChannelId){
        let messageController = chatClient.messageController(cid: channelId, messageId: messageId)
        messageController.synchronize { error in
            self.MessageData.loadMessages(cid: channelId)
            print(error ?? messageController.message!.text)
        }
    }
    
    func loadMessages(cid: ChannelId?) -> [Message] {
        let channelController = chatClient.channelController(for: cid!)
        print(cid)
        var uniqueMessages: Set<Message> = []
        //        do {
        //            let authUser = try Authentication.shared.getAuthUser()
        //            let indices = channelController.messages.indices
        //            for i in indices {
        //                let isMe = channelController.messages[i].author.id == authUser.uid
        //                let messageText = channelController.messages[i].text
        //                var lastMessageStamp: String {
        //                    let formatter = DateFormatter()
        //                    formatter.dateStyle = .none
        //                    formatter.timeStyle = .short
        //                    return formatter.string(from:channelController.messages[i].createdAt )
        //                }
        //                let message = Message(text: messageText, isMe: isMe, timeStamp: lastMessageStamp,CreatedAt: channelController.messages[i].createdAt)
        //                uniqueMessages.insert(message)
        //            }
        //        } catch {
        //            print("Error: \(error)")
        //        }
        //        message = Array(uniqueMessages)
        ////        print(message.count)
        
        channelController.loadNextMessages(limit: 100) { error in
            if let error = error {
                // handle error
                print(error)
            } else {
                // access messages count
                print(channelController.messages.count)
                
                channelController.loadNextMessages(limit: 100) { error in
                    // handle error / access messages
                    print(error ?? channelController.messages.count)
                }
            }
            
        }
       
        return message
    }
}

