//
//  NetworkManager.swift
//  TestAlamofire
//
//  Created by Ning Li on 2019/9/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    var authorizationToken: String?
    
    private var sessionManager: SessionManager
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        sessionManager = SessionManager(configuration: config)
        
    }
    
    private func createSessionManager(timeoutInterval: TimeInterval) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeoutInterval
        sessionManager = SessionManager(configuration: config)
        
        
    }
    
    func request(URLString: String, method: HTTPMethod = .get, parameters: [String: Any]?, timeoutInterval: TimeInterval = 15, complete: @escaping (_ isSuccess: Bool, _ json: Any?) -> Void) {
        let headers: [String: String]?
        if let token = authorizationToken {
            headers = ["Authorization": token]
        } else {
            headers = nil
        }
        let url = URL(string: "\(ApiManager.baseURL)\(URLString)")!
        sessionManager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let error = response.error {
                if (error as NSError).code == -1001 {
                    complete(false, "请求超时")
                } else {
                    complete(false, "请求失败")
                }
            } else {
                guard let data = response.data,
                    let result = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
                    else {
                        complete(false, "请求失败")
                        return
                }
                complete(true, result)
            }
        }
    }
}

extension NetworkManager {
    /// 获取列表数据
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - parameters: 请求参数
    ///   - complete: 完成回调
    func requestListData(URLString: String, parameters: [String: Any]?, complete: @escaping (_ json: Data?, _ errorInfo: String?) -> Void) {
        request(URLString: URLString, parameters: parameters) { (isSuccess, json) in
            if isSuccess {
                guard let result = json as? [String: Any],
                    let dictArray = result["data"] as? [Any],
                    let data = try? JSONSerialization.data(withJSONObject: dictArray, options: [])
                    else {
                        complete(nil, nil)
                        return
                }
                complete(data, nil)
            } else {
                complete(nil, json as? String)
            }
        }
    }
    
    /// 更新数据请求
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - parameters: 请求参数
    ///   - timeoutInterval: 超时时间
    ///   - complete: 完成回调
    func requestUpdate(URLString: String, parameters: [String: Any]?, timeoutInterval: TimeInterval = 15, complete: @escaping (_ isSuccess: Bool, _ message: String?) -> Void) {
        if timeoutInterval != 15 {
            createSessionManager(timeoutInterval: timeoutInterval)
        }
        request(URLString: URLString, method: .put, parameters: parameters, timeoutInterval: 120) { (isSuccess, json) in
            self.createSessionManager(timeoutInterval: 15)
            if isSuccess {
                let res = json as! [String: Any]
                let message = res["message"] as! String
                complete(true, message)
            } else {
                complete(false, json as? String)
            }
        }
    }
}

fileprivate struct ApiManager {
    private static var requestURL: String = ""
    
    static var baseURL: String {
        if requestURL.isEmpty {
            requestURL = "https://apifdev1.mingniao100.com"
            return requestURL
        } else {
            return requestURL
        }
    }
    
    static func invalidate() {
        requestURL = ""
    }
}
