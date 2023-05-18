//
//  SearchResultView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 18/05/2023.
//

import SwiftUI

struct SearchResultView: View {
    var userName:String?
    var name: String?
    @State var url:URL? = nil
    var body: some View {
        HStack{
            if let url = url {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
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
                    .font(.system(size: 22))
                    .padding()
                    .background(Circle().fill(.ultraThinMaterial))
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text(name ?? "Default")
                    .fontWeight(.bold)
                    .padding(.top, 3)
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text(userName ?? "Default")
                    .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.6), .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
            }
            .padding(.horizontal, 10)
          
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}
