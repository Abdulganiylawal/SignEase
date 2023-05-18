import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

@available(iOS 16.0, *)

struct FriendView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    @State var usersCount: Any?
    @State var textLen: Int?
    
    init() {
        _textLen = State(initialValue: searchText.count)
    }
    
    var body: some View {
        NavigationStack {
            Search
                .padding()
            List {
                ForEach(Array(searchManager.shared.users!), id: \.id) { result in
                    if let photoURLString = result.photourl, let url = URL(string: photoURLString) {
                        SearchResultView(userName: result.username, name: result.name, url: url)
                            .swipeActions(edge: .trailing) {
                                Button(action: {
                                    // Perform action for swipe action
                                    print("Swiped: \(String(describing: result.username))")
                                }) {
                                    Label("Add Friend", systemImage: "person.badge.plus")
                                }
                                .tint(.blue)
                            }
                    } else {
                        EmptyView()
                    }
                }
                .id(usersCount as? AggregateQuery)
                .padding()
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
}

@available(iOS 16.0, *)
struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}




