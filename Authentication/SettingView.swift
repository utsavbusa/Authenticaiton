//
//  SettingView.swift
//  Authentication
//
//  Created by Utsav busa on 16/04/23.
//

import SwiftUI

final class SeetingViewModel:ObservableObject{
    
    @Published var authProvider:[AuthProviderOption] = []
    
    func loadauthProvider(){
        if let providers = try? AuthenticationManger.share.getProvider(){
            authProvider = providers
        }
    }
    
    func SignOut() throws{
       try AuthenticationManger.share.signOut()
    }
    func resetPassword() async throws{
        let authUser = try AuthenticationManger.share.getAuthenticedUser()
        
        guard let email = authUser.email else{
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManger.share.resetPassword(email: email)
    }
    
    func updatePassword() async throws{
        let password = "utsav@123"
        
        try await AuthenticationManger.share.updatePassword(password: password)
    }
    
    func updateEmail() async throws{
        let email = "hello123@gmail.com"
        try await AuthenticationManger.share.updateEmail(email: email)
    }
}

struct SettingView: View {
    
    @StateObject private var ViewModel = SeetingViewModel()
    @Binding var showSignInView:Bool
    
    var body: some View {
        List{
            Button("log out"){
                Task{
                    do{
                        try ViewModel.SignOut()
                        showSignInView = true
                    }catch{
                        print(error)
                    }
                }
            }
            if ViewModel.authProvider.contains(.email){
                //Email Function
                EmailFuction
            }
           
            
        }
        .onAppear{
            ViewModel.loadauthProvider()
        }
        .navigationTitle("Setting")
        
    }
        
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SettingView(showSignInView: .constant(false))
        }
    }
}
extension SettingView{
    private var EmailFuction : some View{
        Section{
            Button("Reset Password"){
                Task{
                    do{
                        try await ViewModel.resetPassword()
                        print("Reset Password!")
                    }catch{
                        print(error)
                    }
                }
            }
            Button("Upadate Password"){
                Task{
                    do{
                        try await ViewModel.updatePassword()
                        print("update Password!")
                    }catch{
                        print(error)
                    }
                }
            }
            Button("Upadate email"){
                Task{
                    do{
                        try await ViewModel.updateEmail()
                        print("update email!")
                    }catch{
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email Function")
        }
    }
}
