//
//  PageControl.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/11/6.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    var tintColor: UIColor = UIColor.lightGray
    var currentColor: UIColor = UIColor.black
    
    func makeCoordinator() -> Coordinator {
        Coordinator(pageControl: self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = numberOfPages
        pageControl.pageIndicatorTintColor = tintColor
        pageControl.currentPageIndicatorTintColor = currentColor
//        pageControl.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(_:)), for: .valueChanged)
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    class Coordinator {
        let pageControl: PageControl
        
        init(pageControl: PageControl) {
            self.pageControl = pageControl
        }
        
//        @objc func updateCurrentPage(_ sender: UIPageControl) {
//            pageControl.currentPage = sender.currentPage
//        }
    }
}

struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl(numberOfPages: 3, currentPage: .constant(0))
    }
}
