//
//  ViewController.swift
//  JPush-Test
//
//  Created by Ning Li on 2019/3/26.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    private weak var rectLayer: CAShapeLayer!
    private weak var shapeLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startPoint = CGPoint(x: 0, y: 64)
        let endPoint = CGPoint(x: UIScreen.main.bounds.width, y: 64)
        let controlPoint = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: 207)
        
        let startLayer = CAShapeLayer()
        startLayer.frame = CGRect(origin: startPoint, size: CGSize(width: 5, height: 5))
        
        let endLayer = CAShapeLayer()
        endLayer.frame = CGRect(origin: endPoint, size: CGSize(width: 5, height: 5))
        
        let controlLayer = CAShapeLayer()
        controlLayer.frame = CGRect(origin: controlPoint, size: CGSize(width: 5, height: 5))
        
        let path = UIBezierPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(red: 39 / 255.0, green: 119 / 255.0, blue: 200 / 255.0, alpha: 1).cgColor
        
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
        view.layer.addSublayer(startLayer)
        view.layer.addSublayer(endLayer)
        view.layer.addSublayer(controlLayer)
        self.shapeLayer = shapeLayer
        
        let rectLayer = CAShapeLayer()
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 64)))
        rectLayer.fillColor = UIColor(red: 39 / 255.0, green: 119 / 255.0, blue: 200 / 255.0, alpha: 1).cgColor
        rectLayer.path = rectPath.cgPath
        view.layer.addSublayer(rectLayer)
        self.rectLayer = rectLayer
        
        mainScrollView.delegate = self
        view.bringSubviewToFront(mainScrollView)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance: CGFloat = 100
        var opacity: CGFloat = 0
        if scrollView.contentOffset.y < 0 {
            opacity = 1
        } else {
            opacity = max(1 - scrollView.contentOffset.y / distance, 0)
            
        }
        
        rectLayer.opacity = Float(opacity)
        shapeLayer.opacity = Float(opacity)
    }
}

