import SwiftUI

struct ChatListItem: Identifiable {
    var id = UUID()
    var userName: String?
    var url: String?
    var time = Date()
}

@MainActor
final class ProfileData {
    private var data = ProfileModal()
    
    static let shared = ProfileData()
    
    init() {}
    
    func profile() async throws -> dBUser? {
        if let value = data.user {
            print(value)
            return value
        }
        do {
            try await data.loadCurrentUser()
        } catch {
            // Handle error
        }
        return nil
    }
}

@MainActor
class ChatListViewModel: ObservableObject {
    @Published var chatListItems: [ChatListItem] = []
    
    init() {
        populateChatListItems()
    }
    
    func populateChatListItems() {
        Task {
            do {
                if let profile = try await ProfileData.shared.profile() {
                    try await Task.withGroup(resultType: ChatListItem.self) { group in
                            group.addTask {
                                return ChatListItem(userName: profile.username, url: profile.photourl)
                            }
                        
                        for try await result in group {
                            chatListItems.append(result)
                        }
                    }
                }
            } catch {
                print("Error loading profile: \(error)")
            }
        }
        print(chatListItems)
    }
}
