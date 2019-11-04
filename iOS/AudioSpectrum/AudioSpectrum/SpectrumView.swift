//
//  SpectrumView.swift
//  AudioSpectrum
//
//  Created by Ning Li on 2019/3/13.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class SpectrumView: UIView {
    
    private var barWith: CGFloat = 3
    private var space: CGFloat = 1
    
    var spectra: [[Float]]? {
        didSet {
            guard let spectra = spectra else {
                return
            }
            
            let path = UIBezierPath()
            for (index, amplitude) in spectra[0].enumerated() {
                let x = CGFloat(index) * (barWith + space) + space
                let y = bounds.height * CGFloat(1 - amplitude)
                let bar = UIBezierPath(rect: CGRect(x: x, y: y, width: barWith, height: bounds.height - y))
                path.append(bar)
                let leftMaskLayer = CAShapeLayer()
                leftMaskLayer.path = path.cgPath
                leftGradientLayer.frame = bounds
                leftGradientLayer.mask = leftMaskLayer
            }
        }
    }
    
    private lazy var leftGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        leftGradientLayer.colors = [UIColor(red: 194 / 255.0, green: 21 / 255.0, blue: 0 / 255.0, alpha: 1.0).cgColor,
                                    UIColor(red: 255 / 255.0, green: 197 / 255.0, blue: 67 / 255.0, alpha: 1.0).cgColor]
        leftGradientLayer.locations = [0.6, 1.0]
        layer.addSublayer(leftGradientLayer)
    }
}
