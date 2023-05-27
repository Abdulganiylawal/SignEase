//
//  TitleRow.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 27/05/2023.
//

import SwiftUI

struct TitleRow: View {
    var imageUrl = URL(string: "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8")
    var name = "Sarah Smith"
    var body: some View {
        VStack() {
            AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            Text(name)
                .font(.subheadline).bold()
          
        }
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
    }
}
