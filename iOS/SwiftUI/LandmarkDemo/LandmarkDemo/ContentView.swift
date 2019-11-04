//
//  ContentView.swift
//  LandmarkDemo
//
//  Created by Ning Li on 2019/10/15.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(landmarks) { (landmark) in
                LandmarkCell(landmark: landmark)
            }
        .navigationBarTitle(Text("世界地标"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LandmarkCell: View {
    let landmark: Landmark
    var body: some View {
        NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
            HStack {
                Image(landmark.thumbnailName)
                    .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text(landmark.name)
                        .font(.body)
                    Text(landmark.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
