import SwiftUI
import Firebase


struct SignIn: View {
    @StateObject private var viewModal = SignViewData()
    @Binding var showSignInView: Bool
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
                                mainView.toggle()
                            }
                            return
                        
                        }
                        catch{
                          
                                mainView.toggle()
                            
                        }
                    }
                }
                label: {
                    ButtonView(title: "Sign In")
                }
                
                .padding(.leading,10)
                .padding(.trailing,10)
                .fullScreenCover(isPresented: $mainView) {
                            MainView()
                }
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
                    if #available(iOS 16.0, *) {
                        NavigationStack{
                            SignUp(showSignInView: .constant(true))
                        }
                    } else {
                        // Fallback on earlier versions
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
    }

    
    
struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(showSignInView: .constant(false))
    }
}
