import SwiftUI

@available(iOS 16.0, *)
struct FriendView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    @StateObject private var viewModal = SearchViewData()
    
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
                              viewModal.search = self.searchText
                              viewModal.print()
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
                }
                Text("Cancel")
                    .fontWeight(.bold)
                    .onTapGesture {
                      
                        self.searchText = ""
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




