import Foundation
import FirebaseAuth
import FirebaseCore

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoname: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoname = user.photoURL?.absoluteString
    }
}

class Authentication{
    static let shared = Authentication()
    
    private init() {}
    
    func callAuth(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            throw AuthError.createUserFailed(error)
        }
    }
    
    func getAuthUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AuthError.signOutFailed(error)
        }
    }
    
    func signInUser(email: String, pass: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: pass)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

enum AuthError: Error {
    case createUserFailed(Error)
    case userNotFound
    case signOutFailed(Error)
}
