//
//  LandmarkDetail.swift
//  LandmarkDemo
//
//  Created by Ning Li on 2019/10/15.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct LandmarkDetail: View {
    
    let landmark: Landmark
    @State var zommed: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(landmark.imageName)
                .resizable()
                .aspectRatio(contentMode: zommed ? .fill : .fit)
                .navigationBarTitle(Text(landmark.name), displayMode: .inline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .onTapGesture {
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        self.zommed.toggle()
                    }
            }
            if !zommed {
                Text(landmark.location)
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                    .padding()
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: landmarks[0])
    }
}
