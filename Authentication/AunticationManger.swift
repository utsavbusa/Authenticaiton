//
//  AunticationManger.swift
//  Authentication
//
//  Created by Utsav busa on 16/04/23.
//

import Foundation
import Firebase
import FirebaseAuth

struct AuthDataResultModel{
    let uuid:String
    let email:String?
    let photoUrl:String?
    
    init(user:User){
        self.uuid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption:String{
    case email = "password"
    case google = "goole.com"
}

final class AuthenticationManger{
    
    static let share = AuthenticationManger()
    
    private init(){
        
    }
    
    func getAuthenticedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    
    func getProvider() throws -> [AuthProviderOption]{
       guard let providerData = Auth.auth().currentUser?.providerData else{
           throw URLError(.badServerResponse)
        }
        var providers:[AuthProviderOption] = []
        for provider in providerData{
            print(provider.providerID)
            if let option = AuthProviderOption(rawValue: provider.providerID){
                providers.append(option)
            }else{
//                assertionFailure("provider opation is not found\(provider.providerID)")
            }
        }
        return providers
    }
  
    
    func signOut()throws{
        try Auth.auth().signOut()
    }
}

//MARK:SIGN IN EMAIL
extension AuthenticationManger{
    func createUser(email:String,password:String)async throws -> AuthDataResultModel{
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authResult.user)
        
    }
    
    func signUser(email:String,password:String)async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email:String) async throws{
      try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password:String) async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
        
    }
    
    func updateEmail(email:String) async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
        
    }
    
}

//MARK: SIGN IN SSO
extension AuthenticationManger{
    
    func signWithGoogle(token:GoogleSignInResultModel) async throws -> AuthDataResultModel{
        
        let credential = GoogleAuthProvider.credential(withIDToken: token.idToken, accessToken: token.accessToken)
            
        return try await signIn(credential: credential)
    }
    
        
    func signIn(credential:AuthCredential) async throws -> AuthDataResultModel{
            let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
