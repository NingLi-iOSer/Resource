//
//  ContentView.swift
//  Calculator
//
//  Created by Ning Li on 2019/11/7.
//  Copyright © 2019 yzh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(action: {
            
        }) {
            Text("+")
                .font(.system(size: 42))
                .foregroundColor(.white)
                .frame(width: 88, height: 88)
                .background(Color("operatorBackground"))
                .cornerRadius(44)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
