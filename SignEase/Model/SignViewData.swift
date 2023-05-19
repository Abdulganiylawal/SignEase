import SwiftUI
import Firebase


@MainActor
final class SignViewData:ObservableObject{
    @Published  var text: String = ""
    @Published var password: String = ""
    @Published var value:Bool = false
    
    func signUp() async throws {
        guard !text.isEmpty, !password.isEmpty else {
            print("No email or password found")
            value = false
            return
        }

        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: text) else {
            print("Invalid email format")
            value =  false
            return
        }
        
        let returnedUserData = try await Authentication.shared.callAuth(email: text, pass: password)
        let user = dBUser(userid: returnedUserData.uid, dataCreated: Date(), email: returnedUserData.email, username: nil, photourl: nil, name: nil, gender: nil, photoname: returnedUserData.photoname)
        let friendCollection = friendsDb(dataCreated: Date(), friendsName: nil, friendsUserId: nil, friendsProfileUrl: nil, friendsusername: nil)
        
        try await UserManager.shared.createNewUser(user: user)
        try await FriendManager.shared.createFriendsCollection(Users: friendCollection)
        
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
