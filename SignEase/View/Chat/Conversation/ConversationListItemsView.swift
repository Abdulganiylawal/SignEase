//
//  ConversationViewItems.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 23/05/2023.
//

import SwiftUI

struct ConversationListItemsView: View {
    
    let ConversationName: String
    let avatar: URL
    let lastMessageAt: Date
    let hasUnreadMessages: Bool
    let lastMessage:String
    let isMuted:Bool
    
    var lastMessageStamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: lastMessageAt)
    }
    
    var body: some View {
        HStack{
            ZStack {
                if hasUnreadMessages {
                    Circle()
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 12)
            if let url = avatar {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                      
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
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(ConversationName)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Text(lastMessageStamp)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                }
                HStack(alignment: .top, spacing: 4) {
                    Text(lastMessage)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)
                    
                    if isMuted {
                        Image(systemName: "bell.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondary)
                            .frame(width: 12)
                            .padding(.top, 4)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .background(Color(uiColor: .systemBackground))
    }
}

struct ConversationViewItems_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConversationListItemsView(ConversationName: "Preview Channel", avatar: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/signease.appspot.com/o/users%2Fi0Tca2IFmqOI33CL5cYylZXmuZa2%2F02456CEE-5554-4AE2-8A36-0AB835D0A458.jpeg?alt=media&token=e6a492ac-35dd-4da0-81b5-b0b487d8c878")!, lastMessageAt: Date(), hasUnreadMessages: true, lastMessage: "We have a lot of great ideas to bring forward the SDK in the future and it's going to be great!", isMuted: false)
                .previewLayout(.fixed(width: 400, height: 120))
                .padding()
            ConversationListItemsView(ConversationName: "Preview Channel",avatar: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/signease.appspot.com/o/users%2Fi0Tca2IFmqOI33CL5cYylZXmuZa2%2F02456CEE-5554-4AE2-8A36-0AB835D0A458.jpeg?alt=media&token=e6a492ac-35dd-4da0-81b5-b0b487d8c878")!, lastMessageAt: Date(), hasUnreadMessages: true, lastMessage: "New", isMuted: true)
                .previewLayout(.fixed(width: 400, height: 120))
                .padding()
            
            ConversationListItemsView(ConversationName: "Preview Channel", avatar: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/signease.appspot.com/o/users%2Fi0Tca2IFmqOI33CL5cYylZXmuZa2%2F02456CEE-5554-4AE2-8A36-0AB835D0A458.jpeg?alt=media&token=e6a492ac-35dd-4da0-81b5-b0b487d8c878")!, lastMessageAt: Date(), hasUnreadMessages: false, lastMessage: "We have a lot of great ideas to bring forward the SDK in the future and it's going to be great!", isMuted: true)
                .previewLayout(.fixed(width: 400, height: 120))
                .padding()
            
            ConversationListItemsView(ConversationName: "Preview Channel", avatar: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/signease.appspot.com/o/users%2Fi0Tca2IFmqOI33CL5cYylZXmuZa2%2F02456CEE-5554-4AE2-8A36-0AB835D0A458.jpeg?alt=media&token=e6a492ac-35dd-4da0-81b5-b0b487d8c878")!, lastMessageAt: Date(), hasUnreadMessages: true, lastMessage: "We have a lot of great ideas to bring forward the SDK in the future and it's going to be great!", isMuted: false)
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 400, height: 120))
                .padding()
            
            ConversationListItemsView(ConversationName: "Preview Channel", avatar: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/signease.appspot.com/o/users%2Fi0Tca2IFmqOI33CL5cYylZXmuZa2%2F02456CEE-5554-4AE2-8A36-0AB835D0A458.jpeg?alt=media&token=e6a492ac-35dd-4da0-81b5-b0b487d8c878")!, lastMessageAt: Date(), hasUnreadMessages: false, lastMessage: "We have a lot of great ideas to bring forward the SDK in the future and it's going to be great!", isMuted: true)
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 400, height: 120))
                .padding()
        }
    }
    
}
