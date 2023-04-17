//
//  SignInWithEmail.swift
//  Authentication
//
//  Created by Utsav busa on 16/04/23.
//

import SwiftUI

final class SignWithEmailViewModel:ObservableObject{
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws{
        guard !email.isEmpty , !password.isEmpty else{
            print("no email is or password")
            return
        }
        let _ = try await AuthenticationManger.share.createUser(email: email, password: password)
    }
    func signIn() async throws{
        guard !email.isEmpty , !password.isEmpty else{
            print("no email is or password")
            return
        }
        let _ = try await AuthenticationManger.share.signUser(email: email, password: password)
    }
    
   
}

struct SignInWithEmail: View {
    @Binding var showSignInView:Bool
    
    @StateObject private var viewModel = SignWithEmailViewModel()
    var body: some View {
        VStack{
            TextField("Email...",text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
            
            SecureField("password...",text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
            
            Button{
                if viewModel.email.isEmpty || viewModel.password.isEmpty{
                    return
                }
                Task{
                    do{
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    }catch{
                        print(error)
                    }
                    
                    do{
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    }catch{
                    print(error)
                    }
                }
                
            }label: {
                Text("sign in with email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background (Color.blue)
                    .cornerRadius (10)
            }
            
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}


struct SignInWithEmail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignInWithEmail(showSignInView: .constant(false))
        }
    }
}
