import SwiftUI
import UIKit
import PhotosUI



@available(iOS 16.0, *)
struct ProfileView: View {
    @State var userName = ""
    @State var name = ""
    @State private var selectedImage: UIImage?
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var image:UIImage?
    @Environment(\.presentationMode) var presentationMode
    let genderOptions = ["Male", "Female", "Other"]
    @State private var selectedGender = "Male"
    
    var body: some View {
        
        NavigationStack{
            List {
                Section(){
                    Header
                }.frame(maxWidth: .infinity,alignment: .center)
                    .listSectionSeparator(.hidden)
                Divider()
                    .listSectionSeparator(.hidden)
                
                Section() {
                    HStack{
                        Text("Name").listRowSeparator(.hidden)
                        TextField("", text: $name)
                            .keyboardType(.default)
                            .textFieldStyle(NoPaddingTextFieldStyle())
                            .foregroundColor(.blue)
                    }
                    
                    HStack{
                        Text("UserName")
                        TextField("", text: $userName)
                            .keyboardType(.default)
                            .foregroundColor(.blue)
                    }
                    HStack{
                        Text("Gender")
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(genderOptions, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                }
                
                
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .listRowSeparator(.automatic)
            .environment(\.defaultMinListRowHeight, 50)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Done")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            Task{
                                do{
                                    try await UserManager.shared.UpdateDb(userId: Authentication.shared.getAuthUser().uid, username: userName, name: name, gender: selectedGender,image: image)
                                }
                                catch{
                                    print(error)
                                }
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
    
    var Header:some View{
        VStack{
            if let avatarImage {
                avatarImage
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(40)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 40, opacity: 0.4)
            }
            
            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
        }
        .onChange(of: avatarItem) { _ in
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        image = uiImage
                        avatarImage = Image(uiImage: uiImage)
                        return
                    }
                }
                print("Failed")
            }
        }
        
    }
    
    
    @available(iOS 16.0, *)
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
}

struct NoPaddingTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 32.5)
            .padding(.vertical, 8)
    }
}
