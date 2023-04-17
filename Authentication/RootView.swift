//
//  RootView.swift
//  Authentication
//
//  Created by Utsav busa on 16/04/23.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView:Bool = false
    
    var body: some View {

        ZStack{
            if !showSignInView{
                NavigationStack{
                   SettingView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear{
            let authuser = try? AuthenticationManger.share.getAuthenticedUser()
            self.showSignInView = authuser == nil ? true : false
            
//           try? AuthenticationManger.share.getProvider()
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                    MianScreenBeforeSign(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
