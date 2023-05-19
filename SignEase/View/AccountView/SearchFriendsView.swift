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
    @State var Friends: [friendsDb]? = []
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
                    .padding()
                if let friends = Friends.wrappedValue, !friends.isEmpty {
                    Section(header: Text("Added Friends")) {
                        ForEach(friends, id: \.id) { friend in
                            if let photoURLString = friend.photourl, let url = URL(string: photoURLString) {
                                SearchResultView(userName: friend.username, name: friend.name, url: url)
                            }
                        }
                    }
                }
            }
            .padding(.top)
            .navigationTitle("Add Friend")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
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
                SearchResultView(userName: result.username, name: result.name, url: url)
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            Task {
                                let result:friendsDb =   FriendManager.shared.addFriend(friendId: result.UserId, username: result.username, name: result.name, image: result.photourl)
                                Friends?.append(result)
                            }}) {
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




