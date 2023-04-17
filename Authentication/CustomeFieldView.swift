//
//  CustomeFieldView.swift
//  Authentication
//
//  Created by Utsav busa on 13/04/23.
//

import SwiftUI

struct CustomeFieldView: View {
    
    var hint:String
    @Binding var text:String
    
    @FocusState var isEnable:Bool
    var contentType:UITextContentType = .telephoneNumber
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            TextField(hint,text: $text)
                .keyboardType(.numberPad)
                .textContentType(contentType)
                .focused($isEnable)
            
            ZStack(alignment: .leading){
                Rectangle()
                    .fill(.black.opacity(0.5))
            }
            .frame(height: 2)
            .frame(width: isEnable ? nil : 0,alignment: .leading)
            .animation(.easeInOut(duration: 0.3), value: isEnable)
        }
    }
}

//struct CustomeFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomeFieldView(hint: "fad", text: "dasf")
//    }
//}
