import SwiftUI
import StreamChat
import StreamChatSwiftUI

@available(iOS 16.0, *)
struct AccountView: View {
    
    @State private var signup = false

    @StateObject private var ProfileData = ProfileModal()
    
    @State private var url:URL?
    var body: some View {
        
        NavigationStack(){
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
                                try Authentication.shared.signOut()
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
                        SignUp()
                        
                    }
                }
            }.listStyle(.insetGrouped)
                .navigationTitle("Account")
        }.onAppear {
            Task{
                try await ProfileData.loadCurrentUser()
                if let user = ProfileData.user{
                    self.url = URL(string: user.photourl!)
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
                HStack{
                    Image(systemName: "gear")
                        .padding(.all, 5)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color(hex: "27374D"))
                        .cornerRadius(6)
                    Text("Profile Settings")
                        .fontWeight(.regular)
                        .padding(.leading, 8)
                        .padding(.vertical, 4)
                        
                }
                
            }
            NavigationLink {
                MessageSettingsView()
            } label: {
                HStack{
                    Image(systemName: "message")
                        .padding(.all, 5)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color(hex: "025464"))
                        .cornerRadius(6)
                    Text("Message Settings")
                        .fontWeight(.regular)
                        .padding(.leading, 8)
                        .padding(.vertical, 4)
                }
            }
            NavigationLink {
                SearchFreindsView()
            } label: {
                HStack{
                    Image(systemName: "person.badge.plus")
                        .padding(.all, 5)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color(hex: "482121"))
                        .cornerRadius(6)
                    Text("Add Friends")
                        .fontWeight(.regular)
                        .padding(.leading, 8)
                }

            }
            NavigationLink {
                FriendsView()
            } label: {
                HStack{
                    Image(systemName: "person.3")
                        .padding(.all, 5)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color(hex: "285430"))
                        .cornerRadius(6)
                    Text("Friends List")
                        .fontWeight(.regular)
                        .padding(.leading, 8)
                        .padding(.vertical, 4)
                }
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


