import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

@MainActor
final class ProfileModal: ObservableObject{
    @Published private(set) var user: dBUser? = nil
    
    func loadCurrentUser() async throws {
        let authResult = try  Authentication.shared.getAuthUser()
        self.user = try await UserManager.shared.getUser(userId: authResult.uid)
    }
}


struct dBUser:Codable{
    let userid:String
    let dataCreated:Date?
    let email:String?
    let photourl:String?
    var name: String?
    var gender:String?
    var username: String?
    
    init(auth:AuthDataResultModel){
        self.userid = auth.uid
        self.dataCreated = Date()
        self.email = auth.email
        self.username = nil
        self.gender = nil
        self.photourl = auth.photoUrl
        self.name = nil
    }
    init(
        userid: String,
        dataCreated: Date? = nil,
        email: String? = nil,
        username: String? = nil,
        photourl: String? = nil,
        name: String? = nil,
        gender:String? = nil
    ) {
        self.userid = userid
        self.dataCreated = dataCreated
        self.email = email
        self.username = username
        self.photourl = photourl
        self.name = name
        self.gender = nil
    }
}

final class UserManager{
    static let shared = UserManager()
    private init(){}
    
    private var encoder: Firestore.Encoder {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        return encoder
    }
    
    private var decoder: Firestore.Decoder {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
    
    private let userCollection = Firestore.firestore().collection("Users")
    
    private let storage = Storage.storage().reference()
    

    private func userRefrence(userId:String) -> StorageReference{
        storage.child("users").child(userId)
    }
    
    private func userDocument(userId:String) -> DocumentReference{
        return userCollection.document(userId)
    }
    
    func createNewUser(user:dBUser) async throws{
        try userDocument(userId: user.userid).setData(from:user,merge: false,encoder:encoder)
    }
    
    func getUser(userId:String) async throws -> dBUser{
        try await userDocument(userId: userId).getDocument(as:dBUser.self,decoder:decoder)
        
    }
    
    
    func UpdateDb(userId: String, username: String?, name: String?, gender: String?, image: UIImage?) async throws {
        var data: [String: Any] = [:]
        
        if let name = name, !name.isEmpty {
            data["name"] = name
        }
        
        if let username = username, !username.isEmpty {
            if username.contains("@"){
                data["username"] = username
            }
            else{
                data["username"]  = "@" + username
                print(username)
            }
        }
        
        if let gender = gender, !gender.isEmpty {
            data["gender"] = gender
        }
        
        if let image = image {
            let imageURL = try await uploadImageToStorage(image: image, userId: userId)
            data["photourl"] = imageURL.name
            do {
                _ = try await generateDownloadURL(userId: userId, path: imageURL.name)
//                print("Download URL: \(downloadURL)")
            } catch {
                print("Error: \(error)")
            }
        }
        try await userDocument(userId: userId).updateData(data)
    }
    
   
    func uploadImageToStorage(image: UIImage, userId: String) async throws -> (path: String, name:String) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            throw UploadError.imageConversionFailed
        }
        let fileName = "\(UUID().uuidString).jpeg"
        
 
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploadTask = try await userRefrence(userId: userId).child(fileName).putDataAsync(imageData, metadata: metadata)
           
        guard let path = uploadTask.path , let returnedName = uploadTask.name else{
            throw URLError(.badServerResponse)
        }
        return (path,returnedName)
    }
    
    func generateDownloadURL(userId: String, path: String) async throws -> URL {
        let storageReference = UserManager.shared.userRefrence(userId: userId).child(path)
        let downloadURL = try await storageReference.downloadURL()
        return downloadURL
    }
    
    enum UploadError: Error {
        case imageConversionFailed
    }
}
