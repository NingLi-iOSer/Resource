//
//  PageVC.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/11/6.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct PageVC: UIViewControllerRepresentable {
    
    let featuredVCs: [UIViewController]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let vc = UIPageViewController(transitionStyle: .scroll,
                                      navigationOrientation: .horizontal,
                                      options: [UIPageViewController.OptionsKey.interPageSpacing: 20])
        vc.dataSource = context.coordinator
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([featuredVCs[currentPage]],
                                            direction: .forward,
                                            animated: true)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        let parent: PageVC
        
        init(parent: PageVC) {
            self.parent = parent
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            let currentIndex = parent.featuredVCs.firstIndex(of: viewController)!
            return currentIndex == 0 ? parent.featuredVCs.last : parent.featuredVCs[currentIndex - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            let currentIndex = parent.featuredVCs.firstIndex(of: viewController)!
            return currentIndex == parent.featuredVCs.count - 1 ? parent.featuredVCs.first : parent.featuredVCs[currentIndex + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.featuredVCs.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}

struct PageVC_Previews: PreviewProvider {
    static var previews: some View {
        PageVC(featuredVCs: [], currentPage: .constant(0))
    }
}
