//
//  ViewController.swift
//  QiniuImage
//
//  Created by Ning Li on 2019/4/9.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import Qiniu

class ViewController: UIViewController {
    
    private lazy var images = [UIImage(named: "image2.jpg", in: Bundle.main, compatibleWith: nil)!]

    private var manager: QNUploadManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = QNConfiguration.build { (builder) in
            builder?.setZone(QNFixedZone.zone0())
        }
        let uploadManager = QNUploadManager.sharedInstance(with: config)
        
        
        manager = uploadManager
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let option = QNUploadOption(mime: nil, progressHandler: { (key, percent) in
            print("percent: \(percent)")
        }, params: nil, checkCrc: false, cancellationSignal: nil)
        
        let token = "qYaLzesqnOuKayrbvwVGcRv97-tF-f25I3CsVmwS:qX43P8vv0V9Y5IUK1sWXxAizdI4=:eyJzY29wZSI6Im1pbmdfbmlhbzpNMDAwNTgxMjkxMzcxMzA2L2ltYWdlcy91c2VyUHJvZmlsZUltYWdlLzI3L2Y4NTEzOGQ2LTc1MjItNDQ0Zi05ZDZmLTdjMjIyZmIwN2I2ZSIsImRlYWRsaW5lIjoxNTU0ODAzODcxfQ=="
        let key = "M000581291371306/images/userProfileImage/27/f85138d6-7522-444f-9d6f-7c222fb07b6e"
        print("开始上传")
        images.forEach { (image) in
            let imageData = image.jpegData(compressionQuality: 0.8)!
            manager?.put(imageData, key: key, token: token, complete: { (info, key, resp) in
                print("code: \(info!.statusCode) \n error: \(info!.error), \n resp: \(resp)")
                if info!.isOK {
                    print("上传成功")
                } else {
                    print("上传失败")
                }
            }, option: option)
        }
    }
}

