import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

@available(iOS 16.0, *)

struct SearchFreindsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    @State var usersCount: Any?
    @State var textLen: Int?
    @State private var showAlert = false
    init() {
        _textLen = State(initialValue: searchText.count)
    }
    var body: some View {
        NavigationStack {
            Search
                .padding()
            List {
                searchResultsListView()
                    .id(usersCount as? AggregateQuery)
            }
            .navigationTitle("Add Friend")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .listRowSeparator(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Clear")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            self.searchText = ""
                            self.usersCount = 0
                            searchManager.shared.users = []
                        }
                }
            }
        }
        .onDisappear {
            self.searchText = ""
            searchManager.shared.users = []
            self.usersCount = 0
        }
        .safeAreaInset(edge: .bottom) {
            VStack {}.frame(height: 44)
        }
        .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Friend Alert"),
                        message: Text(FriendManager.shared.alertMessages!),
                        dismissButton: .default(Text("OK")) {
                            showAlert = false
                        }
                    )
                }
    }
    
    var Search: some View {
        VStack {
            HStack {
                Section {
                    TextField("", text: $searchText)
                        .placeholder(when: searchText.isEmpty) {
                            Text("Search By Username")
                                .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        }
                        .customField(icon: "magnifyingglass")
                        .onChange(of: searchText) { newValue in
                            if newValue.count < textLen! || newValue.count > textLen! {
                                searchManager.shared.users = []
                                self.usersCount = 0
                            }
                            textLen = newValue.count
                        }
                }
                Text("Search")
                    .fontWeight(.bold)
                    .onTapGesture {
                        Task {
                            do {
                                if !searchText.isEmpty {
                                    let usersCount = try await searchManager.shared.searchUsers(value: searchText)
                                    self.usersCount = usersCount
                                }
                            } catch {
                                print("Error searching users: \(error.localizedDescription)")
                            }
                        }
                    }
            }
        }
    }
    
    func searchResultsListView() -> some View {
        ForEach(Array(searchManager.shared.users!), id: \.id) { result in
            if let photoURLString = result.photourl, let url = URL(string: photoURLString) {
                FriendsItemView(name: result.name ?? "Default", Username: result.username ?? "Default", url: url)
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            Task{
                                do{
                                    try await  FriendManager.shared.addFriend(friendId: result.UserId, username: result.username, name: result.name, image: result.photourl)
                                        showAlert.toggle()
                                }catch{
                                    print(error)
                                }
                            }
                            
                        }) {
                            Label("", systemImage: "person.badge.plus")
                        }
                        .tint(.blue)
                    }
            } else {
                EmptyView()
            }
        }
        .padding()
    }
}

@available(iOS 16.0, *)
struct SearchFriends_Previews: PreviewProvider {
    static var previews: some View {
        SearchFreindsView()
    }
}




