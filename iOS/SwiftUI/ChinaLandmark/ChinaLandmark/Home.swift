//
//  Home.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/10/17.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    var categories: [String: [Landmark]] {
        .init(grouping: landmarks, by: { $0.category })
    }
    
    var body: some View {
        NavigationView {
            List {
                Image(landmarks[0].imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(categories.keys.sorted(), id: \.self) { categoryName in
                    CategoryCell(categoryName: categoryName, landmarks: self.categories[categoryName]!)
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink(destination: LandmarkList()) {
                    Text("查看所有地标")
                }
            }
            .navigationBarTitle(Text("精选"))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
