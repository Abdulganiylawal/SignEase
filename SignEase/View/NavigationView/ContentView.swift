import SwiftUI
@available(iOS 16.0, *)
struct ContentView: View {
    @State private var showSignUpView: Bool = false
    @Binding var SignInView:Bool
    @StateObject private var ProfileData = ProfileModal()
    var body: some View {
        ZStack{
                NavigationStack{
                    if self.showSignUpView == true {
                        SignUp(showSignUpView: $showSignUpView)
                    }
                    else {
                       RootView()
                    }
                }
        }
        .onAppear{
            let authUser = try? Authentication.shared.getAuthUser()
            self.showSignUpView = authUser == nil
        
        }
     
    }
}

@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(SignInView: .constant(false))
    }
}

