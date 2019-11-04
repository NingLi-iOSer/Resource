//
//  ViewController.swift
//  SteppedProgressBar
//
//  Created by Ning Li on 2019/10/28.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import LNSteppedProgressBar

class ViewController: UIViewController {
    
    private lazy var topTexts = ["Choose", "Click", "Checkout", "Buy", "Pay", "Step"]
//    private lazy var centerTexts = ["1", "2", "3", "4", "5", "0"]
    private lazy var bottomTexts = ["Register", "Login"]
    
    private var maxIndex: Int = -1
    
    private lazy var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    private lazy var progressColor = UIColor(red: 53.0 / 255.0, green: 226.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    private lazy var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)

    private lazy var progressBar = LNSteppedProgressBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBar()
    }
    
    private func setupProgressBar() {
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 40))
        progressBar.center = view.center
        view.addSubview(progressBar)
        
        progressBar.delegate = self
        progressBar.numberOfPoint = 2
        progressBar.lineHeight = 2
        progressBar.radius = 6
        progressBar.progressRadius = 8
        progressBar.progressLineHeight = 1
        progressBar.useLastState = true
        progressBar.selectedBackgroundColor = progressColor
        progressBar.lastStateCenterColor = progressColor
        progressBar.selectedOuterCircleStrokeColor = UIColor.white
        progressBar.lastStateOuterCircleStrokeColor = backgroundColor
        progressBar.currentSelectedTextColor = progressColor
        progressBar.currentSelectedCenterColor = progressColor
        progressBar.stepTextColor = textColorHere
        
        progressBar.completedTillIndex = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let index = progressBar.completedTillIndex
        if index < progressBar.numberOfPoint - 1 {
            progressBar.completedTillIndex = index + 1
            progressBar.currentIndex = index + 1
        }
    }
}

// MARK: - LNSteppedProgressBarDelegate
extension ViewController: LNSteppedProgressBarDelegate {
    func progressBar(_ progressBar: LNSteppedProgressBar, didSelectedItemAt index: Int) {
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
    }
    
    func progressBar(_ progressBar: LNSteppedProgressBar, willSelecteItemAt index: Int) {
        
    }
    
    func progressBar(_ progressBar: LNSteppedProgressBar, canSelectItemAt index: Int) -> Bool {
        return false
    }
    
    func progressBar(_ progressBar: LNSteppedProgressBar, textAt index: Int, position: LNSteppedProgressBarTextLocation) -> String {
        switch position {
        case .top:
            return ""
        case .center:
            return ""
        case .bottom:
            return bottomTexts[index]
        }
    }
}
