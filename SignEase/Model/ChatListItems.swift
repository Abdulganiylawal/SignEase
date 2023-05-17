import SwiftUI

struct ChatListItem: Identifiable {
    var id = UUID()
    var userName: String?
    var url: String?
}

@MainActor
final class ProfileData {
    private var data = ProfileModal()
    static let shared = ProfileData()
    
    init() {}
    
    func profile() async throws -> dBUser? {
        if let value = data.user {
            return value
        }
        do {
            try await data.loadCurrentUser()
        } catch {
            print(error)
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
                        for _ in 0...9 {
                            group.addTask {
                                return ChatListItem(userName: profile.name, url: profile.photourl)
                            }
                            for try await result in group {
                                chatListItems.append(result)
                            }
                        }
                    }
                }
            } catch {
                print("Error loading profile: \(error)")
            }
        }
        
    }
}
