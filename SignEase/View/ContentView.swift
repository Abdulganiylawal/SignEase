import SwiftUI

struct ContentView: View {
    @State private var showSignInView: Bool = false
    @Binding var SignInView:Bool
    var body: some View {
        ZStack{
            if #available(iOS 16.0, *) {
                NavigationStack{
                    if self.showSignInView == true {
                        SignUp(showSignInView: $showSignInView)
                    }
                    else {
                        MainView()
                    }
                     
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .onAppear{
            let authUser = try? Authentication.shared.getAuthUser()
            self.showSignInView = authUser == nil
        }
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(SignInView: .constant(false))
    }
}

