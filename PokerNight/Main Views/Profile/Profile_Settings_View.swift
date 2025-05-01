import SwiftUI
import FirebaseAuth
import _PhotosUI_SwiftUI

struct Profile_Settings_View: View {
    
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    @State private var show_confirmation_sheet: Bool = false
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var name: String = ""
    
    var isFormValid: Bool {
        !name.isEmpty
    }
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                
                Text("Change Profile Photo")
                    .font(.custom("comfortaa", size: 17))
                    .foregroundColor(colorScheme == .light ? .black : .white)
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Change Profile Photo")
                            .font(.custom("comfortaa", size: 14))
                    }
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .gradientColorLeft,
                                        .gradientColorRight
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(radius: 3)
                }
                .onChange(of: selectedItem) {
                    oldItem,
                    newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(
                            type: Data.self
                        ),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            auth_view_model
                                .uploadAndSaveProfilePhoto(image: image)
                        }
                        selectedTab = .dashboard
                    }
                }
                .padding()
                
                Divider()
                
                Text("Change Name")
                    .font(.custom("comfortaa", size: 17))
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .padding()
                TextField("Enter Game Title", text: $name)
                        .submitLabel(.done)
                    .padding()
                    .background(.offBlack)
                    .cornerRadius(4)
                    .foregroundColor(.gray)
                    .font(.custom("roboto-regular", size: 15))
                    .padding(
                        EdgeInsets(top: 0, leading: 1, bottom: 20, trailing: 1)
                    )
                
                Button(
                    action: {
                        auth_view_model.updateDisplayName(newName: name) { success, errorMessage in
                            if success {
                                print("✅ Display name updated in both Auth and Firestore.")
                            } else {
                                print("❌ Error updating name:", errorMessage ?? "Unknown error")
                            }
                        }
                        selectedTab = .dashboard
                    }) {
                        Text("Change Name")
                            .font(.custom("Roboto", size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(gradient)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .opacity(isFormValid ? 1 : 0.5)
                    }
                    .padding()
                    .disabled(!isFormValid)
                
                Divider()
                
                HStack {
                    
                    
                    Button("Delete Account"){
                        show_confirmation_sheet.toggle()
                        
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Button("Log Out"){
                        
                        game_view_model.saveLocalGames([])
                        game_view_model.games = []
                        auth_view_model.Sign_Out()
                        
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    .tint(.yellow)
                }
                
                Spacer()
            }
                .scrollDismissesKeyboard(.immediately)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorScheme)
        }
        .sheet(isPresented: $show_confirmation_sheet) {
            Account_Deletion_Confirmation_View()
                .environmentObject(auth_view_model)
                .presentationDetents([.fraction(0.35)])
                    
        }
    }
}

struct Profile_Settings_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Profile_Settings_View(selectedTab: .constant(.dashboard))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
                .preferredColorScheme(.dark)
            Profile_Settings_View(selectedTab: .constant(.dashboard))
                .environmentObject(Authentication_View_Model())
                .environmentObject(Games_View_Model())
        }
    }
}
