//
//  LandmarkList.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/10/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct LandmarkList: View {
    
    @State private var showPavorite: Bool = false
    @EnvironmentObject var userData: UserData
    
    var body: some View {
            List {
                Toggle(isOn: $showPavorite) {
                    Text("只展示收藏")
                }
                
                ForEach(userData.userLandmarkList) { landmark in
                    if !self.showPavorite || landmark.isFavorite {
                        NavigationLink(destination: LandmarkDetail(landmark: landmark).environmentObject(self.userData)) {
                            LandmarkCell(landmark: landmark)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("中国地标"))
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList().environmentObject(UserData())
    }
}
