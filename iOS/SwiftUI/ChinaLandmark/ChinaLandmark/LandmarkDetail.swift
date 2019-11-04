//
//  LandmarkDetail.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/10/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct LandmarkDetail: View {
    
    let landmark: Landmark
    @EnvironmentObject var userData: UserData
    var landmarkIndex: Int {
        userData.userLandmarkList.firstIndex(where: { $0.id == landmark.id })!
    }
    
    var body: some View {
        VStack {
            MapView(center: landmark.locationCoordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 350)
            
            Image(landmark.imageName)
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(lineWidth: 4).foregroundColor(Color.white))
                .shadow(radius: 10)
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    Button(action: {
                        self.userData.userLandmarkList[self.landmarkIndex].isFavorite.toggle()
                    }) {
                        Image(systemName: landmark.isFavorite ? "star.fill" : "star")
                            .foregroundColor(Color.yellow)
                    }
                }
                HStack {
                    Text(landmark.city)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.province)
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitle(Text(landmark.name), displayMode: .inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LandmarkDetail(landmark: landmarks[0])
                .environmentObject(UserData())
        }
    }
}
