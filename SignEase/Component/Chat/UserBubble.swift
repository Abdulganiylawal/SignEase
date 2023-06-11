//
//  UserBubble.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 27/05/2023.
//

import SwiftUI

struct UserBubble: View {
    @State var color: Color = Color.blue
    @State var content: String = "Lorem Ipsum"
    @State var timeStamp: String = ""
    @State private var toggleTime: Bool = false
 
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(content)
                .fontWeight(.bold)
                .padding(10)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(18, corners: [.topLeft, .topRight, .bottomLeft])
            if toggleTime {
                Text("\(timeStamp)")
                        .font(.system(size: 13, weight: .bold))
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 50, alignment: .trailing)
        .onTapGesture(perform: {
            withAnimation {
                self.toggleTime.toggle()
            }
        })
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
    }
}

struct UserBubble_Previews: PreviewProvider {
    static var previews: some View {
        UserBubble()
    }
}
