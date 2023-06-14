import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

@MainActor
final class FriendsModal: ObservableObject {
    @Published private(set) var user: Set<friendsDb> = []

    func loadCurrentUser() async throws {
        let friends = try await FriendManager.shared.getFriends()
        user = Set(friends)
    }
}


struct friendsDb: Codable, Hashable {
    let friendUserId: String?
    let friendUsername: String?
    let friendName: String?
    let friendProfileUrl: String?
    let dataCreated : Date?
    
    init(
        dataCreated: Date? = nil,
        friendName: String? = nil,
        friendUserId: String? = nil,
        friendProfileUrl: String? = nil,
        friendUsername: String? = nil
    ) {
        self.dataCreated = dataCreated
        self.friendName = friendName
        self.friendUserId = friendUserId
        self.friendProfileUrl = friendProfileUrl
        self.friendUsername = friendUsername
    }
}

@MainActor
final class FriendManager {
    static let shared = FriendManager()
    private init() {}
    var alertMessages:String? = nil
    
    private let userCollection = Firestore.firestore().collection("Users")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId).collection("Friends").document()
    }
    
    
    func addFriend(friendId: String?, username: String?, name: String?, image: String?) async throws {
        guard let userId = try? Authentication.shared.getAuthUser().uid else {
            print("Failed to get authenticated user ID.")
            return
        }

        guard userId != friendId else {
            self.alertMessages = "Can't add yourself as a friend."
            return
        }
        
        
        let friendCollectionRef = userCollection.document(userId).collection("Friends")
        let subcollectionSnapshot = try await friendCollectionRef.limit(to: 1).getDocuments()
        let subcollectionExists = !subcollectionSnapshot.isEmpty
        
        if !subcollectionExists {
            try await userCollection.document(userId).setData(["dataCreated": Date()], merge: true)
        }
        
        // Check if the friend already exists
        let querySnapshot = try await friendCollectionRef.whereField("friendUserId", isEqualTo: friendId as Any).getDocuments()
        if !querySnapshot.isEmpty {
            self.alertMessages = "Friend already exist"
            return
        }
        
        var data: [String: Any] = [:]
        
        if let name = name, !name.isEmpty {
            data["friendName"] = name
        }
        
        if let friendId = friendId, !friendId.isEmpty {
            data["friendUserId"] = friendId
        }
        
        if let username = username, !username.isEmpty {
            if username.contains("@") {
                data["friendUsername"] = username
            } else {
                data["friendUsername"] = "@" + username
            }
        }
        
        if let image = image, !image.isEmpty {
            data["friendProfileUrl"] = image
        }
        
        data["dataCreated"] = Date()
        
        do {
            try await userDocument(userId: userId).setData(data, merge: false)
            self.alertMessages = "Added Friend"
        } catch {
            print("Failed to add friend: \(error)")
            throw error
        }
    }

    
    func getFriends() async throws -> [friendsDb] {
        guard let userId = try? Authentication.shared.getAuthUser().uid else {
            print("Failed to get authenticated user ID.")
            return []
        }
        
        var friends: [friendsDb] = []
        
        let querySnapshot = try await userCollection.document(userId).collection("Friends").getDocuments()
        
        for document in querySnapshot.documents {
            if let friendData = try? document.data(as:  friendsDb.self) {
                friends.append(friendData)
            }
        }
        return friends
    }
}

