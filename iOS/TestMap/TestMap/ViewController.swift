//
//  ViewController.swift
//  TestMap
//
//  Created by Ning Li on 2019/4/22.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import MAMapKit

class ViewController: UIViewController {
    
    private lazy var mapView = MAMapView()

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        search?.delegate = self
        
        let attrM = NSMutableAttributedString(string: "浙江省绍兴市柯桥区浙江省绍兴市柯桥区浙江省绍兴市柯桥区浙江省绍兴市柯桥区\n备注：西华楼对面131313号")
        attrM.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], range: NSMakeRange(0, 36))
        textLabel.attributedText = attrM.copy() as? NSAttributedString
        textLabel.lineBreakMode = .byWordWrapping
        
        mapView.frame = UIScreen.main.bounds
        view.addSubview(mapView)
        
        let path = Bundle.main.url(forResource: "style", withExtension: "data")!
        let data = try! Data(contentsOf: path)
        let options = MAMapCustomStyleOptions()
        options.styleData = data
        mapView.setCustomMapStyleOptions(options)
        mapView.customMapStyleEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let request = AMapGeocodeSearchRequest()
//        request.address = "北京市朝阳区阜荣街10号"
//        search?.aMapGeocodeSearch(request)
    }
}
