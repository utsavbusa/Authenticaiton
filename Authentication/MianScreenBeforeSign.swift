//
//  MianScreenBeforeSign.swift
//  Authentication
//
//  Created by Utsav busa on 16/04/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices


struct SignInWithAppleButtonViewRepresentable:UIViewRepresentable{
    
    let style: ASAuthorizationAppleIDButton.Style
    let type: ASAuthorizationAppleIDButton.ButtonType
    
    func makeUIView(context: Context) -> some UIView {
        ASAuthorizationAppleIDButton(authorizationButtonType:type,authorizationButtonStyle: style)
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}




struct GoogleSignInResultModel{
    let idToken:String
    let accessToken:String
}

final class MianScreenBeforeSignViewModel:ObservableObject{
    
    @Published var didSignInWithApple:Bool = false
    let signInAppleHelper = SignInAppleHelper()
    
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
    
    //    func signInApple() async throws {
    //        let helper = await SignInAppleHelper()
    //            let tokens = try await helper.startSignInWithAppleFlow()
    //            let authDataResult = try await AuthenticationManger.shared.signInWithApple(tokens: tokens)
    //            let user = DBUser(auth: authDataResult)
    //            try await UserManager.shared.createNewUser(user: user)
    //        }
    
    func signInApple() async throws{
        

        signInAppleHelper.startSignInWithAppleFlow { result in
            switch result{
            case .success(let signInAppleResult):
                
                Task{
                    do{
                        try await AuthenticationManger.share.signInWithApple(tokens: signInAppleResult)
                        self.didSignInWithApple = true
                    }
                    catch{
                        
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
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
//
//            Button{
//
//                do {
//                                    try await ViewModel.signInApple()
//                                       showSignInView = false
//                                   } catch {
//                                       print(error)
//                                   }
//
//            }label: {
//                SignInAppleHelper.SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
//                    .allowsTightening(false)
//            }.frame(height: 55)
            
            
            Button{
                
                Task{
                    do{
                        try await ViewModel.signInApple()
                        if ViewModel.didSignInWithApple == true{
                            showSignInView = false
                        }
                        
                    }catch{
                       print(error)
                    }
                }
                
            }label: {
                SignInWithAppleButtonViewRepresentable(style: .black, type: .default)
            }
            .frame(height: 55)
            
           

            
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
