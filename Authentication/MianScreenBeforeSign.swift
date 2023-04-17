//
//  MianScreenBeforeSign.swift
//  Authentication
//
//  Created by Utsav busa on 16/04/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel{
    let idToken:String
    let accessToken:String
}

final class MianScreenBeforeSignViewModel:ObservableObject{
    
    func signInGoogle() async throws{
        guard let topVc = Utilites.shared.topViewController() else{
            throw URLError(.cannotFindHost)
        }
        
        let gidSignResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVc)
        
        guard  let idToken: String = gidSignResult.user.idToken?.tokenString else{
            throw URLError(.badServerResponse)
        }
        let accessToken: String = gidSignResult.user.accessToken.tokenString
        
        let token = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        
        try await AuthenticationManger.share.signWithGoogle(token: token)
    }
    
}


struct MianScreenBeforeSign: View {
    
    @Binding var showSignInView:Bool
    @StateObject var ViewModel = MianScreenBeforeSignViewModel()
    
    var body: some View {
        VStack{
            NavigationLink{
                SignInWithEmail(showSignInView: $showSignInView)
            }label: {
                Text("sign in with email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background (Color.blue)
                    .cornerRadius (10)
                
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark,style: .wide,state: .normal)) {
                Task{
                    do{
                        try await ViewModel.signInGoogle()
                        showSignInView = false
                        
                    }catch{
                       print(error)
                    }
                }
            }
            
            Spacer()
        }.padding()
            .navigationTitle("Sign In")
    }
}

struct MianScreenBeforeSign_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MianScreenBeforeSign(showSignInView: .constant(false))
        }
    }
}
