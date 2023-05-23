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
    let userid:String?
    let dataCreated:Date?
    let email:String?
    let photourl:String?
    let photoname:String?
    let name: String?
    let gender:String?
    let username: String?
    
    init(auth:AuthDataResultModel){
        self.userid = auth.uid
        self.dataCreated = Date()
        self.email = auth.email
        self.username = nil
        self.gender = nil
        self.photourl = nil
        self.name = nil
        self.photoname = auth.photoname
    }
    init(
        userid: String,
        dataCreated: Date? = nil,
        email: String? = nil,
        username: String? = nil,
        photourl: String? = nil,
        name: String? = nil,
        gender:String? = nil,
        photoname:String? = nil
    ) {
        self.userid = userid
        self.dataCreated = dataCreated
        self.email = email
        self.username = username
        self.photourl = photourl
        self.name = name
        self.gender = gender
        self.photoname = photoname
        
    }
}

final class UserManager{
    static let shared = UserManager()
    private init(){}
    var alertManager = AlertManager()
    
    private let userCollection = Firestore.firestore().collection("Users")
    
    private let storage = Storage.storage().reference()
    

    private func userRefrence(userId:String) -> StorageReference{
        storage.child("users").child(userId)
    }
    
    private func userDocument(userId:String) -> DocumentReference{
        return userCollection.document(userId)
    }
    
    func createNewUser(user:dBUser) async throws{
        try userDocument(userId: user.userid!).setData(from:user,merge: false)
    }
    
    func getUser(userId:String) async throws -> dBUser{
        try await userDocument(userId: userId).getDocument(as:dBUser.self)
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
                        }
        }
        
        if let gender = gender, !gender.isEmpty {
            data["gender"] = gender
        }
        
        if let image = image {
            let imageURL = try await uploadImageToStorage(image: image, userId: userId)
            do {
                let downloadURL = try await generateDownloadURL(userId: userId, path: imageURL.name)
                print("Download URL: \(downloadURL)")
                data["photourl"] = downloadURL.absoluteString
                data["photoname"] = imageURL.name
            } catch {
                print("Error: \(error)")
            }
        }
        let db = Firestore.firestore()
        let querySnapshot = try await db.collection("Users").whereField("username", isEqualTo: username!).getDocuments()
        if !querySnapshot.isEmpty{
            print("Already exist this username")
            return
        }
        try await userDocument(userId: userId).updateData(data)
    }
    
   
    func uploadImageToStorage(image: UIImage, userId: String) async throws -> (path: String, name:String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
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
        let storageReference = userRefrence(userId: userId).child(path)
        let downloadURL = try await storageReference.downloadURL()
        return downloadURL
    }
    
        enum UploadError: Error {
            case imageConversionFailed
        }
}
