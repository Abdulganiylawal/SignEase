

import SwiftUI

struct NotUserBubble: View {
    @State var color: Color = Color.gray
    @State var content: String = "Lorem Ipsum"
    @State var timeStamp: String = ""
   
    @State private var toggleTime: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(content)
                .fontWeight(.bold)
                .padding(10)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(18, corners: [.bottomLeft, .topRight, .bottomRight])
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                
                .frame(width: UIScreen.main.bounds.size.width - 50, alignment: .leading)
            if toggleTime {
                HStack(spacing: 0) {
                    Text("\(timeStamp)")
                        .font(.system(size: 13, weight: .bold))
                    
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 50, alignment: .leading)
        .onTapGesture(perform: {
            withAnimation {
                self.toggleTime.toggle()
            }
        })
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
    }
}

struct NotUserBubble_Previews: PreviewProvider {
    static var previews: some View {
        NotUserBubble()
    }
}
