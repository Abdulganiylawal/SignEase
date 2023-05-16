import SwiftUI

@MainActor
final class MainViewModel:ObservableObject{
    func SignOut()throws{
        try Authentication.shared.signOut()
    }
}

@available(iOS 16.0, *)
struct AccountView: View {
    @StateObject private var viewModal = MainViewModel()
    @State private var signup = false
    
    @StateObject private var ProfileData = ProfileModal()

    @State private var url:URL?
    var body: some View {
        
        NavigationStack{
            List{
                Section{
                    profile
                }
                Section{
                    lawal
                }
                Section{
                    Button {
                        Task{
                            do{
                                try viewModal.SignOut()
                                signup.toggle()
                            }
                            catch{
                                print(error)
                            }
                        }
                    } label: {
                        Text("Sign out")
                            .frame(maxWidth: .infinity)
                    }
                    .fullScreenCover(isPresented:$signup ) {
                        SignUp(showSignUpView: $signup)
                        
                    }
                }
            }.listStyle(.insetGrouped)
                .navigationTitle("Account")
        }.onAppear {
            Task{
                try await ProfileData.loadCurrentUser()
                if let user = ProfileData.user , let path = user.photourl{
                    self.url = try await UserManager.shared.generateDownloadURL(userId: user.userid, path: path)
                }
            }
        }
    }
    var profile: some View {
        
        VStack(alignment:.center) {
            if let url = url {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(40)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 40, opacity: 0.4)
                } placeholder: {
                    ProgressView()
                }
            }
            else{
                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                    .symbolVariant(.circle.fill)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .blue.opacity(0.3), .red)
                    .font(.system(size: 32))
                    .padding()
                    .background(Circle().fill(.ultraThinMaterial))
            }
            VStack{
                Text(ProfileData.user?.name ?? "Default")
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Text(ProfileData.user?.username ?? "Default")
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text(ProfileData.user?.gender ?? "Default")
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text(ProfileData.user?.email ?? "Default")
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    var lawal: some View {
        Section {
            NavigationLink {
                ProfileView()
            } label: {
                Label("Profile Settings", systemImage: "gear")
            }
            NavigationLink {} label: {
                Label("Chat History", systemImage: "message")
            }
        }
        .listRowSeparator(.automatic)
    }
    
    
}

@available(iOS 16.0, *)
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}


