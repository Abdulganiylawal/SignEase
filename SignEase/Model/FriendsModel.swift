import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

@MainActor
final class FriendsModal: ObservableObject {
    @Published private(set) var user: friendsDb? = nil
    
    func loadCurrentUser() async throws {
        let authResult = try Authentication.shared.getAuthUser()
        self.user = try await FriendManager.shared.getUser(userId: authResult.uid)
    }
}



struct friendsDb:Identifiable,Codable{
    var id = UUID()
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

    func createFriendsCollection(Users: friendsDb)async throws{
        try userDocument(userId: Authentication.shared.getAuthUser().uid).setData(from:Users,merge: false,encoder:encoder)
    }
    func addFriend(friendId: String?, username: String?, name: String?, image: String?)  {
        guard !friends.contains(where: { $0.friendUserId == friendId }) else {
            print("Friend already exists.")
          return
        }
        let friend = friendsDb(dataCreated: Date(), friendsName: name, friendsUserId: friendId, friendsProfileUrl: image, friendsusername: username)
        friends.append(friend)
        print(friends)

    }

    func getUser(userId:String) async throws -> friendsDb{
        try await userDocument(userId: userId).getDocument(as:friendsDb.self,decoder:decoder)
    }
}
