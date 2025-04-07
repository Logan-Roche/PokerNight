import SwiftUI

struct User_Profile_View: View {
    @EnvironmentObject var viewModel: Authentication_View_Model
    @Environment(\.dismiss) var dismiss
    @State var presentingConfirmationDialog = false
    
    private func deleteAccount() {
        Task {
            if await viewModel.Delete_Account() == true {
                dismiss()
            }
        }
    }
    
    private func signOut() {
        viewModel.Sign_Out()
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 100 , height: 100)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .clipped()
                            .padding(4)
                            .overlay(
                                Circle().stroke(Color.accentColor, lineWidth: 2)
                            )
                        Spacer()
                    }
                    Button(action: {}) {
                        Text("edit")
                    }
                }
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            Section("Email") {
                Text(viewModel.display_name)
            }
            Section {
                Button(role: .cancel, action: signOut) {
                    HStack {
                        Spacer()
                        Text("Sign out")
                        Spacer()
                    }
                }
            }
            Section {
                Button(
                    role: .destructive,
                    action: { presentingConfirmationDialog.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Text("Delete Account")
                            Spacer()
                        }
                    }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                            isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
            Button("Delete Account", role: .destructive, action: deleteAccount)
            Button("Cancel", role: .cancel, action: { })
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            User_Profile_View()
                .environmentObject(Authentication_View_Model())
        }
    }
}
