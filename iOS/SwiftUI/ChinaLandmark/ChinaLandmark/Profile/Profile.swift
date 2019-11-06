//
//  Profile.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/11/6.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct Profile: View {
    
    @Environment(\.editMode) var mode
    
    @State var user = User.default
    @State var userCopy = User.default
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                if mode?.wrappedValue == .active {
                    Button(action: {
                        self.user = self.userCopy
                        self.mode?.animation().wrappedValue = .inactive
                    }) {
                        Text("完成")
                    }
                }
                Spacer()
                EditButton()
            }
            
            if mode?.wrappedValue == .inactive {
                List{
                    Text(user.userName)
                        .font(.largeTitle)
                        .bold()
                    Text("允许通知:  \(user.prefersNotifications ? "是" : "否")")
                    Text("喜欢的季节:  \(user.prefersSeason.rawValue)")
                    Text("生日:  \(user.birthday, formatter: dateFormatter)")
                    VStack(alignment: .leading) {
                        Text("最近的徒步旅行:")
                            .font(.headline)
                        HikeView(hike: hikes[0])
                    }
                }
            } else {
                ProfileEditor(userCopy: $userCopy)
                    .onDisappear {
                        self.userCopy = self.user
                }
            }
        }
        .padding()
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
