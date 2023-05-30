//
//  MessageSettingsView.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 30/05/2023.
//

import SwiftUI

struct MessageSettingsView: View {
    @AppStorage("ChatViewSelection") var selectedView = "Standard"
    let options = ["Standard", "SignLanguageChatView"]
    var body: some View {
        VStack {
                   Picker("Select an option", selection: $selectedView) {
                       ForEach(options, id: \.self) { option in
                           Text(option)
                       }
                   }
                   .pickerStyle(.segmented)
                   
                   Text("Selected option: \(selectedView)")
                       .padding()
               }
               .padding()
    }
}

struct MessageSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MessageSettingsView()
    }
}
