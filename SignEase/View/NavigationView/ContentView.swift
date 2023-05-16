import SwiftUI

struct ContentView: View {
    @State private var showSignUpView: Bool = false
    
    
    @Binding var SignInView:Bool
    var body: some View {
        ZStack{
            if #available(iOS 16.0, *) {
                NavigationStack{
                    if self.showSignUpView == true {
                        SignUp(showSignUpView: $showSignUpView)
                    }
                    else {
                       RootView()
                    }
                }
            } else {
                // Fallback on earlier versions
            }
         
        }
        .onAppear{
            let authUser = try? Authentication.shared.getAuthUser()
            self.showSignUpView = authUser == nil
        }
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(SignInView: .constant(false))
    }
}

