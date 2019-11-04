//
//  ViewController.swift
//  GSCDownload
//
//  Created by Ning Li on 2019/6/23.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {
    
    private lazy var manager = AFHTTPSessionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.responseSerializer.acceptableContentTypes?.insert("application/xml")
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    @IBAction func download(_ sender: Any) {
        let URLString = "https://51gsc.com/openapi/downloadurl"
        let id = "4053757903bca8245216aa3c83cefc47"
//        manager.post(URLString, parameters: ["id": id], progress: nil, success: { (task, json) in
//            print(json)
//            if let result = json as? [String: Any],
//                let data = result["data"] as? [String: Any],
//                let urlString = data["url"] as? String,
//                let url = URL(string: urlString) {
//                UIApplication.shared.open(url, options: [:], completionHandler: { (flag) in
//                    print(flag)
//                })
//            }
//        }) { (_, error) in
//
//        }
        
        let url = URL(string: URLString)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let param = ["id": id]
        request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String: Any],
                    let dataDict = json["data"] as? [String: Any],
                    let URLString = dataDict["url"] as? String,
                    let url = URL(string: URLString)
                    else {
                        return
                }
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
}

