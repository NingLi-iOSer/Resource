//
//  ViewController.swift
//  CustomCamera
//
//  Created by Ning Li on 2019/12/10.
//  Copyright © 2019 yzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var camera: CustomCamera?
    private var imageCropView: ImageContainerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera = CustomCamera.camera(delegate: self)
        
        view.insertSubview(camera!, at: 0)
        
    }
        
    private func settingImageCropView(image: UIImage) {
        imageCropView = ImageContainerView(image: image)
        view.addSubview(imageCropView!)
    }
    
    @IBAction func takePhoeo(_ sender: Any) {
//        camera?.takePhoto()
    }
}

// MARK: - CustomCameraDelegate
extension ViewController: CustomCameraDelegate {
    func camera(_ camera: CustomCamera, takePicture image: UIImage) {
        settingImageCropView(image: image)
    }
    
    func cameraDidClickBack(_ camera: CustomCamera) {
        
    }
}

