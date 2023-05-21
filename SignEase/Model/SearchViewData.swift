import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore



struct SearchData: Identifiable,Codable{
    var id = UUID()
    var UserId:String?
    var photourl:String?
    var username: String?
    var name:String?
    
}


final class searchManager{
    static var shared = searchManager()
    private init (){}
    var users: [SearchData]? = []
    let db = Firestore.firestore()
    var usersCount:Any?
    
    func searchUsers(value: String) async throws -> Any? {
        let query = db.collection("Users").whereField("username", isGreaterThanOrEqualTo: value)
            do { 
                let snapshot = try await query.getDocuments()
                for document in snapshot.documents {
                    let documentData = document.data()
                    self.users?.append(SearchData(UserId: documentData["userid"] as? String, photourl: documentData["photourl"] as? String, username: documentData["username"] as? String, name: documentData["name"] as? String))
                }
            }catch{
                print(error)
            }
        
        let countQuery = query.count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            usersCount = snapshot.count
        } catch {
            print(error);
        }
        return usersCount
    }
}
