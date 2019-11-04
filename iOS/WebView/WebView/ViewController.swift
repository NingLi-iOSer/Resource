//
//  ViewController.swift
//  WebView
//
//  Created by Ning Li on 2019/6/15.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.baidu.com")!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
        let cache = URLCache.shared
        
        if let cacheResponse = cache.cachedResponse(for: request) {
            webView.load(cacheResponse.data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: url)
        } else {
            webView.load(request)
            
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            let response = URLResponse(url: url, mimeType: "text/html", expectedContentLength: 0, textEncodingName: "UTF-8")
            let cacheResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cacheResponse, for: request)
        }
        
//        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        let content = "PGgxIHN0eWxlPSJ0ZXh0LWFsaWduOiBjZW50ZXI7Ij48c3BhbiBzdHlsZT0iZm9udC13ZWlnaHQ6IGJvbGQ7Ij7luIPljLnnirbmgIHor7TmmI48L3NwYW4+PC9oMT48ZGl2PjxzcGFuIHN0eWxlPSJmb250LXdlaWdodDogYm9sZDsiPjxicj48L3NwYW4+PC9kaXY+PGRpdiBzdHlsZT0idGV4dC1hbGlnbjogY2VudGVyOyI+PHNwYW4gc3R5bGU9ImJhY2tncm91bmQtY29sb3I6IHJnYigxOTQsIDc5LCA3NCk7Ij4g5biD5Yy55b2T5YmN5bqT5a2Y5LiN5YeG56GuPC9zcGFuPjxzcGFuIHN0eWxlPSJmb250LXdlaWdodDogYm9sZDsiPjxicj48L3NwYW4+PC9kaXY+PHAgc3R5bGU9InRleHQtYWxpZ246IGNlbnRlcjsiPjxzcGFuIHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOiByZ2IoMjQ5LCAxNTAsIDU5KTsiPjxpbWcgc3JjPSJodHRwOi8vaW1nLnQuc2luYWpzLmNuL3Q0L2FwcHN0eWxlL2V4cHJlc3Npb24vZXh0L25vcm1hbC8zYy9wY21vcmVuX3d1X29yZy5wbmciIGFsdD0iW+axoV0iIGRhdGEtdy1lPSIxIiBzdHlsZT0idGV4dC1hbGlnbjogbGVmdDsiPiZuYnNwO+W4g+WMueW9k+WJjeW6k+WtmOS4jeWHhuehrjwvc3Bhbj48L3A+PHAgc3R5bGU9InRleHQtYWxpZ246IGNlbnRlcjsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDI4LCA3MiwgMTI3KTsiPjxpbWcgc3JjPSJodHRwOi8vaW1nLnQuc2luYWpzLmNuL3Q0L2FwcHN0eWxlL2V4cHJlc3Npb24vZXh0L25vcm1hbC81MC9wY21vcmVuX2h1YWl4aWFvX29yZy5wbmciIGFsdD0iW+Wdj+eskV0iIGRhdGEtdy1lPSIxIiBzdHlsZT0idGV4dC1hbGlnbjogbGVmdDsiPiZuYnNwO+W4g+WMueW9k+WJjeW6k+WtmOS4jeWHhuehrjwvc3Bhbj48YnI+PC9wPjxoMiBzdHlsZT0idGV4dC1hbGlnbjogY2VudGVyOyI+PHNwYW4gc3R5bGU9ImJhY2tncm91bmQtY29sb3I6IHJnYigyNDksIDE1MCwgNTkpOyI+PGltZyBzcmM9Imh0dHA6Ly9pbWcudC5zaW5hanMuY24vdDQvYXBwc3R5bGUvZXhwcmVzc2lvbi9leHQvbm9ybWFsLzQwL3BjbW9yZW5fdGlhbl9vcmcucG5nIiBhbHQ9IlvoiJTlsY9dIiBkYXRhLXctZT0iMSIgc3R5bGU9InRleHQtYWxpZ246IGxlZnQ7Ij4mbmJzcDvluIPljLnlvZPliY3lupPlrZjkuI3lh4bnoa48L3NwYW4+PC9oMj48cD48YnI+PC9wPjxkaXYgc3R5bGU9InRleHQtYWxpZ246IGNlbnRlcjsiPjxicj48L2Rpdj4="
//
////        var jsonString = content.utf8CString
////        let data = Data(bytes: &jsonString, count: jsonString.count)
////        let text = String(data: data, encoding: .ascii)
////        print(text)
//
//        guard let decodeData = Data(base64Encoded: content, options: Data.Base64DecodingOptions.init(rawValue: 0)),
//            let htmlString = String(data: decodeData, encoding: .utf8)
//            else {
//                return
//        }
//        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

