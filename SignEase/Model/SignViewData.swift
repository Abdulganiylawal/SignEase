import SwiftUI
import Firebase


@MainActor
final class SignViewData:ObservableObject{
    @Published  var text: String = ""
    @Published var password: String = ""
    @Published var value:Bool = false
    
    func signUp() async throws{
        guard !text.isEmpty, !password.isEmpty else{
            print("No email or password Found")
            return
        }
        let returnedUserData = try await Authentication.shared.callAuth(email: text, pass: password)
        let user = dBUser(userid: returnedUserData.uid, dataCreated: Date(), email: returnedUserData.email, username: nil,  photourl: returnedUserData.photoUrl,name: nil,gender: nil)
        try await UserManager.shared.createNewUser(user: user)
        
        value = true
    }
    
    func signIn() async throws{
        guard !text.isEmpty, !password.isEmpty else{
            print("No email or password Found")
            return
        }
       _ = try await Authentication.shared.signInUser(email: text, pass: password)
        value = true
    }
    
}
