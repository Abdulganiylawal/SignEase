//
//  ConversationHeader.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 23/05/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct ConversationHeader: ToolbarContent {
    var title:String? = nil
    @State var showNewChat:Bool = false
    var body: some ToolbarContent {
        ToolbarItem(placement:.principal) {
            Text(title!)
                .bold()
        }
    }
}


