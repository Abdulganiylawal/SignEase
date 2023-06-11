
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth


@available(iOS 16.0, *)
struct SignUp: View {
    @StateObject private var viewModal = SignViewData()
    @StateObject private var profileData = ProfileModal()
    @Environment(\.presentationMode) var presentationMode
    @State private var mainView = false
    @State private var SignInView = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding(.leading,10)
                    .padding(.bottom,20)
                Section{
                    TextField("", text: $viewModal.text)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .placeholder(when: viewModal.text.isEmpty) {
                            Text("Email address")
                                .foregroundColor(.primary)
                                .blendMode(.overlay)
                        }
                        .customField(icon: "envelope.open.fill")
                    SecureField("", text: $viewModal.password)
                        .textContentType(.password)
                        .placeholder(when: viewModal.password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.primary)
                                .blendMode(.overlay)
                        }
                        .customField(icon: "key.fill")
                    
                }
                .padding(.leading,10)
                .padding(.trailing,10)
                .padding(.bottom,10)
                
                Button {
                    Task{
                        do{
                            try await viewModal.signUp()
                            if viewModal.value == true{
                                DispatchQueue.main.async {
                                    mainView.toggle()
                                }
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
                        catch {
                            handleError(error as! SignViewError)
                        }
                    }
                } label: {
                    ButtonView(title: "Create Account")
                }.alert(item: $viewModal.error) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
                .padding(.leading,10)
                .padding(.trailing,10)
                .fullScreenCover(isPresented: $mainView) {
                    NavigationStack{
                        RootView()
                    }
                }
                Divider()
                    .padding(5)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                HStack{
                    Text("Already have an account?")
                        .font(.subheadline)
                        .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.7), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Button {
                        SignInView.toggle()
                    } label: {
                        Text("Sign In")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                .fullScreenCover(isPresented:$SignInView){
                    NavigationStack{
                        SignIn()
                    }
                }
                
                .padding(.leading,20)
            }.padding(15)
                .frame(width: 400,height: 370)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
                .strokeStyle(cornerRadius: 30)
                .padding(20)
        }.background(
            Image("Background 4")
        )
    }
    private func handleError(_ error: SignViewError) {
        viewModal.error = error
    }
}

@available(iOS 16.0, *)
struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
