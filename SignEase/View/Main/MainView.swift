//
//  MainView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 13/05/2023.
//

import SwiftUI



struct MainView: View {
    @State private var ShowScreen: Bool = false
    var body: some View {
        ZStack {
            Image("Background 4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
            VStack {
                Text("Sign Language Communicator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .frame(width: 300)
                HStack {
                    Button(action: {
                        ShowScreen.toggle()
                        print("hello")
                    }
                    ) {
                        Text("Start")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 50)
                    .background(Color.blue,in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .padding(.trailing, 20)
                    .sheet(isPresented: $ShowScreen) {
                        CommunicatorView()
                        
                    }
                    Button(action: {
                        // Do something when the second button is tapped
                    }) {
                        Text("Join")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 50)
                    .background(Color.green,in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                    
                    .padding(.leading, 20)
                }
                .padding(.bottom, 50)
                          
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                MainView()
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
}
