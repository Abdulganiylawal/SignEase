import Foundation
import StreamChat
import StreamChatSwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFunctions
import FirebaseFunctionsCombineSwift

struct Messanger: Identifiable {
    let id = UUID()
    let sender: String
    let text: String
    
}



struct ChatData {
    static var messages = [
        Messanger(sender: "John", text: "Hello!"),
        Messanger(sender: "Jane", text: "Hi there!"),
        Messanger(sender: "John", text: "How are you?"),
        Messanger(sender: "Jane", text: "I'm good, thanks!"),
        Messanger(sender: "John", text: "Nice weather today, isn't it?"),
        Messanger(sender: "Jane", text: "Yes, it's beautiful!")
    ]
}

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
        var str = username
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


    enum ChatManagerError: Error {
        case currentUserNotFound
    }
}

