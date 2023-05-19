//
//  FriendsView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 19/05/2023.
//

import SwiftUI

struct FriendsView: View {
    @StateObject var FriendsData = FriendsModal()
    var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                Task{
                    do{
                        try await FriendsData.loadCurrentUser()
                    }catch{
                     print(error)
                    }
                }
            }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
