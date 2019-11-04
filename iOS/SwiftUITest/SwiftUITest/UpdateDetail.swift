//
//  UpdateDetail.swift
//  SwiftUITest
//
//  Created by Ning Li on 2019/7/17.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct UpdateDetail : View {
    
    var title: String = "SwiftUI"
    var text: String = "Loading..."
    var image: String = "Illustration1"
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.heavy)
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            Text(text)
                .lineLimit(nil)
                .frame(minWidth: 0, maxWidth: .infinity)
            Spacer()
        }
        .padding(30)
    }
}

#if DEBUG
struct UpdateDetail_Previews : PreviewProvider {
    static var previews: some View {
        UpdateDetail()
    }
}
#endif
