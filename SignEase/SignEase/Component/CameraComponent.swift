//
//  CameraComponent.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 11/04/2023.
//

import SwiftUI

struct CameraComponent: View {
    var body: some View {
        VStack{
            CameraView()
            AugmentedReality()
        }
      
    }
}

struct CameraComponent_Previews: PreviewProvider {
    static var previews: some View {
        CameraComponent()
    }
}
