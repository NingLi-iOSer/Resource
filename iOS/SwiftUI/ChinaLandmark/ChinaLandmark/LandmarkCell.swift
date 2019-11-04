//
//  LandmarkCell.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/10/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct LandmarkCell: View {
    
    let landmark: Landmark
//    @EnvironmentObject var userData: UserData
    
    var body: some View {
        HStack {
            Image(landmark.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            
            Text(landmark.name)
            
            Spacer()
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            }
        }
    }
}

struct LandmarkCell_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkCell(landmark: landmarks[2])
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
