//
//  ViewController.swift
//  PopGesture
//
//  Created by Ning Li on 2019/3/28.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTF: HighlightedTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTF.setSubfixImage(#imageLiteral(resourceName: "unvisiable_icon"), for: .normal)
        inputTF.setSubfixImage(#imageLiteral(resourceName: "visiable_icon"), for: .selected)
        inputTF.subfixButton.addTarget(self, action: #selector(changedPasswordTextType(sender:)), for: .touchUpInside)
        inputTF.layer.borderColor = UIColor(red: 151 / 255.0, green: 151 / 255.0, blue: 151 / 255.0, alpha: 0.3).cgColor
        inputTF.layer.cornerRadius = 8
        inputTF.layer.borderWidth = 1
        
        let grandLayer = CAGradientLayer()
        grandLayer.colors = [UIColor(red: 109 / 255.0, green: 190 / 255.0, blue: 250 / 255.0, alpha: 1).cgColor,
                             UIColor(red: 39 / 255.0, green: 119 / 255.0, blue: 200 / 255.0, alpha: 1).cgColor]
        grandLayer.startPoint = CGPoint(x: 0, y: 0.5)
        grandLayer.endPoint = CGPoint(x: 1, y: 0.5)
        grandLayer.locations = [0, 1]
        grandLayer.frame = CGRect(origin: CGPoint(), size: CGSize(width: 300, height: 40))
        grandLayer.cornerRadius = 8
        loginButton.layer.addSublayer(grandLayer)
//        view.layer.addSublayer(grandLayer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let contentView = UIView(frame: CGRect())
        contentView.backgroundColor = UIColor.orange
        
        FilterContainerView.show(contentView: contentView)
    }
    
    @objc private func changedPasswordTextType(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        inputTF.isSecureTextEntry = !sender.isSelected
    }
}

