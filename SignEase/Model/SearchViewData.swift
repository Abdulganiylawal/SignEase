import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore



struct SearchData: Identifiable,Codable{
    var id = UUID()
    let email:String?
    let photourl:String?
    let username: String?
    let name:String?
}


final class searchManager:ObservableObject{
    static var shared = searchManager()
    private init (){}
    var users: [SearchData]? = []
    let db = Firestore.firestore()
    
    func searchUsers(value: String)  {
        if value.isEmpty {
            users = []
            return
        }
        
        let query = db.collection("Users").whereField("username", isGreaterThanOrEqualTo: value)
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error searching users: \(error.localizedDescription)")
                return
            }
            else{
                for document in snapshot!.documents {
                    let documentData = document.data()
                    self.users?.append(SearchData(email: documentData["email"] as? String, photourl: documentData["photourl"] as? String, username: documentData["username"] as? String, name:(documentData["name"] as? String)))
                }
            }

            guard let _ = snapshot?.documents else {
                print("No documents found")
                return
            }
        }
    }
}
