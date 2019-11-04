//
//  UpdateStore.swift
//  SwiftUITest
//
//  Created by Ning Li on 2019/7/17.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI
import Combine

class UpdateStore: ObservableObject {
    
    var didChange = PassthroughSubject<Void, Never>()
    
    var updates: [Update] {
        didSet {
            didChange.send()
        }
    }
    
    init(updates: [Update] = []) {
        self.updates = updates
    }
}
