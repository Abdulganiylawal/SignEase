//
//  MessageList.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 23/05/2023.
//

import SwiftUI
import StreamChat

@available(iOS 16.0, *)
extension ConversationView{
    
    func makeChannelHeaderViewModifier(for channel: ChatChannel) -> MessageListHeaderModifier {
            MessageListHeaderModifier(channel: channel)
        }
}
