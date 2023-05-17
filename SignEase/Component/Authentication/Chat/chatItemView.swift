//
//  chatItems.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 17/05/2023.
//

import SwiftUI

struct chatItems: View {
    var userName:String = "ss"
    var message: String = "Hello"
    @StateObject private var ProfileData = ProfileModal()
    @State var url:URL? = nil
    var body: some View {
        HStack{
            if let url = url {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 65, height: 65)
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
            VStack{
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        Text(userName)
                            .fontWeight(.semibold)
                            .padding(.top, 3)
                    }

                    Text(message)
                        .foregroundColor(.blue).opacity(0.5)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    Divider()
                        .padding(.top, 8)
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

struct chatItems_Previews: PreviewProvider {
    static var previews: some View {
        chatItems()
    }
}
