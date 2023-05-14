import Foundation
import FirebaseAuth
import FirebaseCore

struct AuthDataResultModel{
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

@MainActor
class Authentication:ObservableObject
{
    static let shared = Authentication()
    init(){}
    let auth = Auth.auth()
    
    func callAuth(email:String,pass:String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: pass)
        return AuthDataResultModel(user:authDataResult.user)
    }
    
    func getAuthUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    func signInUser(email:String,pass:String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: pass)
        return AuthDataResultModel(user:authDataResult.user)
    }
}

