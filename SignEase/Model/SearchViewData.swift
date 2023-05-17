//
//  SearchViewData.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 17/05/2023.
//

import Foundation

class SearchViewData:ObservableObject{
    @Published var search = ""
    @Published var Friends:Array = []
    
    func print(){
        Swift.print(self.search)
    }
}
