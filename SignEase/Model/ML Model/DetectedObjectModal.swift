//
//  DetectedObject.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 03/06/2023.
//

import Foundation

@MainActor
final class DetectedObjectModal: ObservableObject{
    @Published var recognizedObjects: [String] = []
    static let shared = DetectedObjectModal()
    init(){}
}


