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
    
    @State var showProfile: Bool = false
    @State var currentPage: Int = 0
    
    let pages: [UIViewController]
    
    init() {
        pages = featuredLandmarks.map {
            UIHostingController(rootView:
                Image($0.imageName)
                    .resizable()
                    .scaledToFill()
            )
        }
    }
    
    var body: some View {
        NavigationView {
            
            List {
                ZStack(alignment: .bottom) {
                    PageVC(featuredVCs: pages, currentPage: $currentPage)
                        .frame(height: 200)
                    PageControl(numberOfPages: featuredLandmarks.count, currentPage: $currentPage)
                }
                .listRowInsets(EdgeInsets())
                
                ForEach(categories.keys.sorted(), id: \.self) { categoryName in
                    CategoryCell(categoryName: categoryName, landmarks: self.categories[categoryName]!)
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink(destination: LandmarkList()) {
                    Text("查看所有地标")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("精选"))
            .navigationBarItems(trailing:
                Button(action: {
                    self.showProfile.toggle()
                }, label: {
                    Image(systemName: "person.crop.circle")
                        .renderingMode(.original)
                        .imageScale(.large)
                })
            ).sheet(isPresented: $showProfile) {
                Profile()
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
