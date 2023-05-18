//
//  SwiftUIView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 18/05/2023.
//

import SwiftUI
import UIKit
//struct   SwiftUIView

struct   SwiftUIView: View {
    @State private var isShowingSwipeActions = false
    
    var body: some View {
        VStack {
            Text("Swipe me")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < -50 {
                                isShowingSwipeActions = true
                            }
                        }
                        .onEnded { value in
                            isShowingSwipeActions = false
                        }
                )
                .overlay(
                    swipeActionsView()
                        .opacity(isShowingSwipeActions ? 1 : 0)
                        .offset(x: isShowingSwipeActions ? -120 : 0)
                        .animation(.default)
                )
        }
        .padding()
    }
    
    @ViewBuilder
    private func swipeActionsView() -> some View {
        HStack {
            Button(action: {
                // Perform action
                print("Pin action")
            }) {
                Label("Pin", systemImage: "pin")
            }
            .tint(.yellow)
            .padding(.trailing, 16)
            
            Button(action: {
                // Perform action
                print("Delete action")
            }) {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        .frame(height: 60)
        .background(Color.white)
    }
}


struct Swift_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

