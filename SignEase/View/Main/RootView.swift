//
//  RootView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 15/05/2023.
//

import SwiftUI

struct RootView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .chat
    var body: some View {
        ZStack{
            Group {
                if #available(iOS 16.0, *) {
                    switch selectedTab {
                    case .chat:
                        CameraView()
                 
                    case .account:
                        ProfileView()
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {}.frame(height: 44)
            }
            TabBar()
        }
      
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
