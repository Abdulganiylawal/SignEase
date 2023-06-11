import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth


@available(iOS 16.0, *)
struct SignIn: View {
    @StateObject private var viewModal = SignViewData()
    @StateObject private var profileData = ProfileModal()
    @State private var SignUpView = false
    @State private var mainView = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6),.primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
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
                    Task{ ()
                        do{
                            try await viewModal.signIn()
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
                        catch{
                            handleError(error as! SignViewError)
                        }
                    }
                }
            label: {
                ButtonView(title: "Sign In")
            }
            .alert(item: $viewModal.error) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
                
            .padding(.leading,10)
            .padding(.trailing,10)
                            .fullScreenCover(isPresented: $mainView) {
                                NavigationStack{
                                    RootView()
                                }.navigationViewStyle(.stack)
                            }
                .navigationBarBackButtonHidden(true)
                Divider()
                    .padding(5)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                HStack{
                    Text("No account yet?")
                        .font(.subheadline)
                        .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.7), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Button {
                        SignUpView.toggle()
                    } label: {
                        Text("Sign Up")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                .fullScreenCover(isPresented:$SignUpView){
                    NavigationStack{
                        SignUp()
                    }
                }.padding(.leading,20)
            }.padding(15)
                .frame(width: 400,height: 400)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
                .strokeStyle(cornerRadius: 30)
                .padding(20)
        }.background(
            Image("Background")
        )
        
        
    }
    private func handleError(_ error: SignViewError) {
        viewModal.error = error
    }
}


@available(iOS 16.0, *)
struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
