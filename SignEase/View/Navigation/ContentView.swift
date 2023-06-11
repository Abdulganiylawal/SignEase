import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    @StateObject private var profileData = ProfileModal()
    @AppStorage("showSignUpView") private var showSignUpView = false
    var body: some View {
        NavigationStack {
            if showSignUpView {
                SignUp()
            } else {
                RootView()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
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
}

@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

