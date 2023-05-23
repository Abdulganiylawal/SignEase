

import SwiftUI

struct MessageListHeader: ToolbarContent {
    
    @ObservedObject var viewModel: MessageListHeaderViewModal
    @Binding var isInfoSheetShown: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Button {
                isInfoSheetShown.toggle()
            } label: {
                VStack(spacing: 4) {
                    if let headerImage = viewModel.headerImage {
                        Image(uiImage: headerImage)
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else {
                        Circle()
                            .fill(.cyan)
                            .frame(width: 20, height: 20)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(viewModel.channelName ?? "Unknown")
                            .font(.caption)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 6)
            }
        }
    }
}
