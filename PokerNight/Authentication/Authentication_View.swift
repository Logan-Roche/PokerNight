import SwiftUI
import Combine

struct Authentication_View: View {
    @EnvironmentObject var viewModel: Authentication_View_Model
    
    var body: some View {
        VStack {
            switch viewModel.flow {
            case .login:
                Log_In_View()
                    .environmentObject(viewModel)
            case .signUp:
                Sign_Up_View()
                    .environmentObject(viewModel)
            }
        }
    }
}

struct Authentication_View_Previews: PreviewProvider {
    static var previews: some View {
        Authentication_View()
            .environmentObject(Authentication_View_Model())
    }
}
