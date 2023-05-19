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
        print(user.count)
    }
}



struct friendsDb:Codable{
    let friendUserId: String?
    let friendUsername: String?
    let friendName: String?
    let frienndProfileUrl:String?
    let dataCreated:Date?
    init(
        dataCreated: Date? = nil,
        friendsName:String? = nil,
        friendsUserId:String? = nil,
        friendsProfileUrl:String? = nil,
        friendsusername:String? = nil
    ) {

        self.dataCreated = dataCreated
        self.friendName = friendsName
        self.friendUserId = friendsUserId
        self.frienndProfileUrl =  friendsProfileUrl
        self.friendUsername = friendsusername
    }
}

@MainActor
final class FriendManager{
    static let shared = FriendManager()
    private init(){}
    var friends: [friendsDb] = []
    private var decoder: Firestore.Decoder {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
    private var encoder: Firestore.Encoder {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        return encoder
    }

    private let userCollection = Firestore.firestore().collection("Users")

    private func userDocument(userId:String) -> DocumentReference{
        return userCollection.document(userId).collection("Friends").document()
    }

    func createFriendsCollection(Users: friendsDb)async throws {
        try await userDocument(userId: Authentication.shared.getAuthUser().uid).setData(from:Users,merge: false,encoder:encoder)
    }
    
    func addFriend(friendId: String?, username: String?, name: String?, image: String?) async throws {
        var data: [String: Any] = [:]
        
        guard !friends.contains(where: { $0.friendUserId == friendId }) else {
            print("Friend already exists.")
            return
        }
        
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
            let userId = try Authentication.shared.getAuthUser().uid
            try await userDocument(userId: userId).setData(data, merge: true)
        } catch {
            print("Failed to add friend: \(error)")
        }
    }

    func getFriends() async throws -> [friendsDb] {
        let userId = try Authentication.shared.getAuthUser().uid
            let querySnapshot = try await userCollection.document(userId).collection("Friends").getDocuments()
            for document in querySnapshot.documents {
                if let friendData = try? document.data(as: friendsDb.self, decoder: decoder) {
                    friends.append(friendData)
                }
            }
       
            return friends
        }
}

extension friendsDb: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendUserId)
    }

    static func ==(lhs: friendsDb, rhs: friendsDb) -> Bool {
        lhs.friendUserId == rhs.friendUserId
    }
}
