//
//  CategoryCell.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/10/17.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct CategoryCell: View {
    let categoryName: String
    let landmarks: [Landmark]
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(landmarks) { landmark in
                        CategoryItem(landmark: landmark)
                    }
                }
            }
        }
        .padding(.leading, 15)
        .padding([.top, .bottom])
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCell(categoryName: landmarks[0].category,
                     landmarks: Array(landmarks.prefix(4)))
    }
}

struct CategoryItem: View {
    let landmark: Landmark
    var body: some View {
        NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
            VStack(alignment: .leading) {
                Image(landmark.imageName)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .cornerRadius(8)
                Text(landmark.name)
                    .foregroundColor(.primary)
            }
        }
    }
}
