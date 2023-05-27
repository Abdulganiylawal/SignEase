//
//  RootView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 15/05/2023.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

@available(iOS 16.0, *)
struct RootView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .chat
    @State var showNewChat:Bool = false
    var body: some View {
        ZStack{
            Group {
                switch selectedTab {
                case .chat:
                    Conversation
                case .account:
                     AccountView()
                }
                
            }
            .safeAreaInset(edge: .bottom) {
                VStack {}.frame(height: 44)
            }
            TabBar()
        }
        
    }
    
    var Conversation: some View{
        ChatChannelListView(viewFactory: ConversationView()).navigationTitle("Chats").toolbar {
            ToolbarItem(placement:.navigationBarLeading){
                Button {
                    // Tbd
                } label: {
                    Text("Edit")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showNewChat.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                    
                }.sheet(isPresented: $showNewChat) {
                    NewChatView()
                }
            }
        }.safeAreaInset(edge: .bottom) {
            VStack {}.frame(height: 44)
        }
    }
}


