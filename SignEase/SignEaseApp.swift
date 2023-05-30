import SwiftUI
import FirebaseCore
import StreamChat
import StreamChatSwiftUI
import FirebaseFunctions
import FirebaseFunctionsCombineSwift

class AppDelegate: NSObject, UIApplicationDelegate, EventsControllerDelegate {
    
    var streamChat: StreamChat?
    lazy var profileData = ProfileModal()
    var eventsController: EventsController!
    
 
    var chatClient: ChatClient = {
        var config = ChatClientConfig(apiKey: .init("3n2z86vjm8wc"))
        config.applicationGroupIdentifier = "group.io.getstream.iOS.ChatDemoAppSwiftUI"

        let client = ChatClient(config: config)
        return client
    }()

    internal func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil)-> Bool {
        FirebaseApp.configure()
        streamChat = StreamChat(chatClient: chatClient)
        eventsController = chatClient.eventsController()
        eventsController.delegate = self
        connectUser()
        return true
    }
    
    func eventsController(_ controller: EventsController, didReceiveEvent event: Event) {
        
        switch event {
        case let event as MessageNewEvent:
            print(event.message)
        default:
            break
        }
        
    }

    private func connectUser() {
        let functions = Functions.functions()
        functions.httpsCallable("ext-auth-chat-getStreamUserToken").call { [weak self] (result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let token = result?.data as? String else {
                print("Invalid response data")
                return
            }

            let streamToken = try! Token(rawValue: token)

            Task {
                do {
                    try await self?.profileData.loadCurrentUser()
                    if let user = self?.profileData.user,
                       let photoUrl = user.photourl,
                       let userId = user.userid,
                       let username = user.username {
                        self?.chatClient.connectUser(userInfo: .init(id: userId, name: username, imageURL: URL(string: photoUrl)), token: streamToken)
                        print("User connected successfully!")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

}

@available(iOS 16.0, *)
@main
struct SignEaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
//            ChatChannelListView(viewFactory: ConversationView())
        }
    }
}
