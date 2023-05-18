import SwiftUI

@available(iOS 16.0, *)
struct FriendView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    
    @State var textLen:Int?
    init() {
        _textLen = State(initialValue: searchText.count)
    }
    
    
    var body: some View {
        NavigationStack{
            Search
                .padding()
            List{
                
            }
            .padding(.top)
            .navigationTitle("Add Friend")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Done")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
    
    var Search: some View{
        VStack{
            HStack{
                Section{
                    TextField("", text: $searchText)
                        .placeholder(when: searchText.isEmpty) {
                            Text("Search SignEase")
                                .foregroundColor(.primary)
                                .blendMode(.overlay)
                        }.customField(icon: "magnifyingglass")
                        .onChange(of: searchText) { newValue in
                            if newValue.count < textLen! ||  newValue.count > textLen! {
                                 searchManager.shared.users = []
                            }
                            textLen = newValue.count
                            searchManager.shared.searchUsers(value: searchText)
                        }
                }
                Text("Cancel")
                    .fontWeight(.bold)
                    .onTapGesture {
                       
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




