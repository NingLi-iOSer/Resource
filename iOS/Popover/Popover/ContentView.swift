//
//  ContentView.swift
//  Popover
//
//  Created by Ning Li on 2019/12/2.
//  Copyright © 2019 yzh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var isPresented: Bool = true
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            Text("Popover")
        }.popover(isPresented: $isPresented, content: {
            Text("Hello")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
