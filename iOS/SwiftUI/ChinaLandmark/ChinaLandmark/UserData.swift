//
//  UserData.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/10/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    @Published var userLandmarkList = landmarks
}
