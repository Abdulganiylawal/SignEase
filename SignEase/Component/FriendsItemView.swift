//
//  FriendsItemView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 19/05/2023.
//

import SwiftUI

struct FriendsItemView: View {
        var name:String = "ss"
        var Username: String = "Hello"
        var frame:CGFloat = 65
        var padding:CGFloat = 3
        @State var url:URL? = nil
        var body: some View {
            HStack{
                if let url = url {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: frame, height: frame)
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
                    VStack(alignment: .leading, spacing: padding){
                        HStack{
                            Text(name)
                                .fontWeight(.semibold)
                                .padding(.top, padding)
                        }
                        Text(Username)
                            .foregroundColor(.blue).opacity(0.5)
                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
    
}
struct FriendsItemView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsItemView()
    }
}
