//
//  ViewController.swift
//  CircleView
//
//  Created by Ning Li on 2019/9/10.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var circleLayer: LNCircleLayer?
    
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width: CGFloat = 120
        let config = LNCircleLayerConfiguration(lineWidth: 5,
                                                lineColor: UIColor.groupTableViewBackground,
                                                startPoint: CGPoint(x: width * 0.5, y: 0),
                                                endPoint: CGPoint(x: width * 0.5, y: width),
                                                colors: [UIColor.blue, UIColor.red, UIColor.green],
                                                colorSize: [0, 0.6, 1])
        let frame = CGRect(x: (UIScreen.main.bounds.width - width) * 0.5,
                           y: (UIScreen.main.bounds.height - width) * 0.5,
                           width: width,
                           height: width)
        circleLayer = LNCircleLayer(frame: frame, configuration: config)
        view.layer.addSublayer(circleLayer!)
        
        circleLayer!.setProgress(slider.value)
    }
    
    @IBAction func changed(_ sender: UISlider) {
        circleLayer?.setProgress(sender.value)
    }
    
}

