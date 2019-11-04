//
//  ViewController.swift
//  CustomCamera
//
//  Created by Ning Li on 2019/4/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var camera: LLSimpleCamera?

    @IBOutlet weak var navHeightCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        navHeightCons.constant = UIApplication.shared.statusBarFrame.height + 44
        
        camera = LLSimpleCamera(quality: AVCaptureSession.Preset.high.rawValue, position: LLCameraPosition.init(0), videoEnabled: false)
        camera?.attach(to: self, withFrame: view.bounds)
        camera?.fixOrientationAfterCapture = false
        camera?.onDeviceChange = { [weak self] (camera, device) in
            if camera!.isFlashAvailable() {
                
            }
        }
        
        camera?.start()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    /// 切换前后置
    @IBAction private func switchCamera() {
        camera?.togglePosition()
    }
    
    /// 拍照
    @IBAction func takePhoto(_ sender: Any) {
        camera?.capture({ (_, image, _, _) in
            if image != nil {
                let vc = SearchImageControllerViewController.instance(image: image!)
                self.present(vc, animated: false, completion: nil)
            }
        })
    }
}

