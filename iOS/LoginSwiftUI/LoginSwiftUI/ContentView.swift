//
//  ContentView.swift
//  LoginSwiftUI
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var phone: String = ""
    @State var isPhoneTFFocus: Bool = false
    @State var validateCode: String = ""
    @State var isValidateCodeTFFocus: Bool = false
    
    var body: some View {
        Background {
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Image("login_bg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom)
                    
                    Text("欢迎来到鸣鸟")
                        .font(.system(size: 20, weight: Font.Weight.bold))
                        .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.4))
                        .padding(EdgeInsets(top: 53, leading: 30, bottom: 0, trailing: 0))
                    HighlightedTextField(phone: $phone, prefixImage: "login_mobile")
                        .padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30))
//                    HighlightedTextField(prefixImage: "login_mobile", formatter: CustomNumberFormatter(length: 11))
                    TextField("", text: $validateCode, onEditingChanged: { (flag) in
                        self.isValidateCodeTFFocus = flag
                    })
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                        .frame(height: 44)
                        .background(Color.white)
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(lineWidth: isValidateCodeTFFocus ? 0 : 0.5).foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.59)))
                        .shadow(color: isValidateCodeTFFocus ? Color.black.opacity(0.25) : Color.clear, radius: 6, x: 0, y: 2)
                        .keyboardType(.numberPad)
                        .onTapGesture {
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image("app-logos")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
                .offset(y: 160)
                }
        }.onTapGesture {
            self.endEditing()
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        print(phone)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Background<Content: View>: View {
    private var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Color.white
            .overlay(content)
            .edgesIgnoringSafeArea(.all)
    }
}
