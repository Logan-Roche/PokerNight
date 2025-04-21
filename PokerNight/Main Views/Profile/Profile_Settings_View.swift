import SwiftUI
import FirebaseAuth
import _PhotosUI_SwiftUI

struct Profile_Settings_View: View {
    
    
    @EnvironmentObject var game_view_model: Games_View_Model
    @EnvironmentObject var auth_view_model: Authentication_View_Model
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tabs
    
    @State private var selectedItem: PhotosPickerItem?
        @State private var selectedImage: UIImage?
    
    let gradient = LinearGradient(
        colors: [.gradientColorLeft, .gradientColorRight],
        startPoint: .top,
        endPoint: .topTrailing
    )
    
    
    var body: some View {
        GeometryReader { geometry in
                VStack {
                    
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
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(
                                    colors: [.gradientColorLeft, .gradientColorRight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        )
                        .shadow(radius: 3)
                    }
                    .onChange(of: selectedItem) { oldItem, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                                auth_view_model.uploadAndSaveProfilePhoto(image: image)
                            }
                        }
                    }

                    Button("Log Out"){
                        auth_view_model.Sign_Out()
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorScheme)
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
