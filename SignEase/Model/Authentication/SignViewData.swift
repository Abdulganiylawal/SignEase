import SwiftUI
import Firebase
import StreamChat
import StreamChatSwiftUI
import FirebaseFunctions
import FirebaseFunctionsCombineSwift


enum SignViewError: Error, Identifiable {
    case emptyEmailOrPassword
    case invalidEmailFormat
    case signUpError
    case signInError

    var id: String {
        switch self {
        case .emptyEmailOrPassword:
            return "emptyEmailOrPassword"
        case .invalidEmailFormat:
            return "invalidEmailFormat"
        case .signUpError:
            return "signUpError"
        case .signInError:
            return "signInError"
        }
    }

    var message: String {
        switch self {
        case .emptyEmailOrPassword:
            return "Please provide both email and password."
        case .invalidEmailFormat:
            return "Invalid email format."
        case .signUpError, .signInError:
            return "Email or Password is wrong"
        }
    }
}

@MainActor
final class SignViewData: ObservableObject {
    @Published var text: String = ""
    @Published var password: String = ""
    @Published var error: SignViewError? = nil
    var value: Bool = false
    
    func signUp() async throws {
        guard !text.isEmpty, !password.isEmpty else {
            value = false
            throw SignViewError.emptyEmailOrPassword
        }
        
        guard isValidEmail(text) else {
            value = false
            throw SignViewError.invalidEmailFormat
        }
        
        do {
            let returnedUserData = try await Authentication.shared.callAuth(email: text, password: password)
            let user = dBUser(userid: returnedUserData.uid, dataCreated: Date(), email: returnedUserData.email, username: nil, photourl: nil, name: nil, gender: nil, photoname: returnedUserData.photoname)
            try await UserManager.shared.createNewUser(user: user)
            value = !returnedUserData.uid.isEmpty
        } catch {
            throw SignViewError.signUpError
        }
    }
    
    func signIn() async throws {
        guard !text.isEmpty, !password.isEmpty else {
            throw SignViewError.emptyEmailOrPassword
        }
        
        guard isValidEmail(text) else {
            value = false
            throw SignViewError.invalidEmailFormat
        }
        
        do {
            let returnedUserData = try await Authentication.shared.signInUser(email: text, pass: password)
            value = !returnedUserData.uid.isEmpty
        } catch {
            print(error)
            throw SignViewError.signInError
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
