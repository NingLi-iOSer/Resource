//
//  TestView.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/11/7.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Text("应用程序开发：使用苹果官方模版制作应用图标 - Sketch + Xcode")
        }
        .contextMenu() {
            Button(action: {
                
            }) {
                HStack {
                    Text("Copy")
                    Image(systemName: "rectangle.on.rectangle.angled")
                }
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
