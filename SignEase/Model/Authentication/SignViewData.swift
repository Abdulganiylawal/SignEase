import SwiftUI
import Firebase
import StreamChat
import StreamChatSwiftUI
import FirebaseFunctions
import FirebaseFunctionsCombineSwift

final class SignViewData: ObservableObject {
    @Published var text: String = ""
    @Published var password: String = ""
    var value: Bool = false
    
    func signUp() async throws {
        guard !text.isEmpty, !password.isEmpty else {
            print("No email or password found")
            value = false
            return
        }
        
        guard isValidEmail(text) else {
            print("Invalid email format")
            value = false
            return
        }
        
        do {
            let returnedUserData = try await Authentication.shared.callAuth(email: text, password: password)
            let user = dBUser(userid: returnedUserData.uid, dataCreated: Date(), email: returnedUserData.email, username: nil, photourl: nil, name: nil, gender: nil, photoname: returnedUserData.photoname)
            try await UserManager.shared.createNewUser(user: user)
            value = !returnedUserData.uid.isEmpty
        } catch {
            print("Sign up error: \(error)")
            throw error
        }
    }
    
    func signIn() async throws {
        guard !text.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        do {
            let returnedUserData = try await Authentication.shared.signInUser(email: text, pass: password)
            value = !returnedUserData.uid.isEmpty
        } catch {
            print("Sign in error: \(error)")
            throw error
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
