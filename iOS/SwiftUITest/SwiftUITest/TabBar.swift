//
//  TabBar.swift
//  SwiftUITest
//
//  Created by Ning Li on 2019/7/17.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct TabBar : View {
    var body: some View {
        TabView {
            Home().tabItem {
                Image("IconHome")
                Text("Home")
            }
            .tag(1)
            ContentView().tabItem {
                Image("IconCards")
                Text("Certificate")
            }
            .tag(2)
            UpdateList().tabItem {
                Image("IconSettings")
                Text("Settings")
            }
            .tag(3)
        }
    }
}

#if DEBUG
struct TabBar_Previews : PreviewProvider {
    static var previews: some View {
        TabBar()
            .environment(\.colorScheme, .dark)
    }
}
#endif
