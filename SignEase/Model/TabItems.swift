
import SwiftUI
struct TabItem: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var selection: Tab
}

var tabItems = [
    TabItem(name: "Chat", icon: "message", color: .teal, selection: .chat),
    TabItem(name: "Account", icon: "person", color: .blue, selection:.account )

]

enum Tab: String {
    case chat
    case account
   
}
