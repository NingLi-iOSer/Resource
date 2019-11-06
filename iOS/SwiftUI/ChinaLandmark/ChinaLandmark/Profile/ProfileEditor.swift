//
//  ProfileEditor.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/11/6.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct ProfileEditor: View {
    
    @Binding var userCopy: User
    
    var body: some View {
        List {
            HStack {
                Text("昵称")
                Divider()
                TextField("昵称", text: $userCopy.userName)
            }
            Toggle(isOn: $userCopy.prefersNotifications) {
                Text("允许通知")
            }
            VStack(alignment: .leading) {
                Text("喜欢的季节")
                    .bold()
                Picker("喜欢的季节", selection: $userCopy.prefersSeason) {
                    ForEach(User.Season.allCases, id: \.self) { (season) in
                        Text(season.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("生日")
                    .bold()
                DatePicker("", selection: $userCopy.birthday, displayedComponents: .date).datePickerStyle(DefaultDatePickerStyle())
            }
            .padding(.top)
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(userCopy: .constant(.default))
    }
}
