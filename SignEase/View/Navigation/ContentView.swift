import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    @State private var showSignUpView = false
    @StateObject private var profileData = ProfileModal()

    var body: some View {
        NavigationStack {
            if showSignUpView {
                SignUp()
            } else {
                RootView()
            }
        }
        .onAppear {
            let authUser = try? Authentication.shared.getAuthUser()
            showSignUpView = authUser == nil
            Task {
                do {
                    try await profileData.loadCurrentUser()
                    if let user = profileData.user,
                       let photoUrl = user.photourl,
                       let userId = user.userid,
                       let username = user.username {
                       ChatManager.shared.connectUser(userId: userId, username: username, photoURL: photoUrl)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

