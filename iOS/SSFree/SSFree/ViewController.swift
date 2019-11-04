//
//  ViewController.swift
//  SSFree
//
//  Created by Ning Li on 2019/10/21.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import NetworkExtension
import Eureka
import Lottie

class ViewController: FormViewController {
    
    let defaultStand = UserDefaults.init(suiteName: "group.test.SSFree")
    
    let firstSection : Section = Section()
    
    var secondSection : Section = Section()
    
    var switchRow : SwitchRow = SwitchRow("switchRowTag")
    
    var status: SSVPNStatus {
        didSet(o) {
            updateConnectButton()
        }
    }
    
    required init?(coder: NSCoder) {
        self.status = SSVPNManager.shared.vpnStatus
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(kProxyServiceVPNStatusNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestBaidu()
        
        title = "SSVPN"
        form +++ firstSection
            <<< TextRow("IP", { (row) in
                row.title = "IP"
                row.placeholder = "Enter server ip here"
                row.value = self.defaultStand!.string(forKey: SSUserConfig().ip)
            }).onChange({ (row) in
                SSVPNManager.shared.ip_address = row.value ?? ""
                self.defaultStand?.set(row.value, forKey: SSUserConfig().ip)
            })
            <<< TextRow("Port", { (row) in
                row.title = "Port"
                row.placeholder = "Enter port here"
                row.value = self.defaultStand!.string(forKey: SSUserConfig().port)
            }).onChange({ (row) in
                SSVPNManager.shared.port = Int(row.value ?? "0")!
                self.defaultStand?.set(row.value ?? "", forKey: SSUserConfig().port)
            })
            <<< PasswordRow("Password", { (row) in
                row.title = "Password"
                row.placeholder = "Enter password here"
                row.value = self.defaultStand!.string(forKey: SSUserConfig().password)
            }).onChange({ (row) in
                SSVPNManager.shared.password = row.value ?? ""
                self.defaultStand?.set(row.value, forKey: SSUserConfig().password)
            })
            <<< PushRow<String>("Crypto", { (row) in
                row.title = "Crypto"
                row.selectorTitle = "Pick crypto algorithm"
                row.options = ["RC4MD5","SALSA20","CHACHA20","AES128CFB","AES192CFB","AES256CFB"]
                row.value = self.defaultStand!.string(forKey: SSUserConfig().algorithm)
            }).onChange({ (row) in
                SSVPNManager.shared.ip_address = row.value ?? ""
                self.defaultStand?.set(row.value, forKey: SSUserConfig().algorithm)
            })
        +++ secondSection
            <<< switchRow.onChange({ (row) in
                if SSVPNManager.shared.vpnStatus == .off && row.value! && !SSVPNManager.shared.ip_address.isEmpty && SSVPNManager.shared.port != 0 && !SSVPNManager.shared.password.isEmpty && !SSVPNManager.shared.algorithm.isEmpty {
                    SSVPNManager.shared.connect()
                } else if SSVPNManager.shared.vpnStatus == .on && !row.value! {
                    SSVPNManager.shared.disconnect()
                }
            }).cellSetup({ (cell, row) in
                if SSVPNManager.shared.vpnStatus == .on {
                    row.value = true
                } else {
                    row.value = false
                }
            })
        
        setupAnimationView()
    }
    
    private func setupAnimationView() {
        let animView = AnimationView(name: "animation")
        animView.backgroundColor = UIColor.white
        animView.frame = UIScreen.main.bounds
        animView.play { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                animView.alpha = 0
            }) { (_) in
                animView.removeFromSuperview()
            }
        }
        view.addSubview(animView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        status = SSVPNManager.shared.vpnStatus
    }
    
    private func updateConnectButton() {
        let ipRow = form.rowBy(tag: "IP")
        let portRow = form.rowBy(tag: "Port")
        let passwordRow = form.rowBy(tag: "Password")
        let cryptoRow = form.rowBy(tag: "Crypto")
        switch status {
        case .on:
            switchRow.value = true
            ipRow?.disabled = true
            portRow?.disabled = true
            passwordRow?.disabled = true
            cryptoRow?.disabled = true
        case .off:
            switchRow.value = false
            ipRow?.disabled = false
            portRow?.disabled = false
            passwordRow?.disabled = false
            cryptoRow?.disabled = false
        default:
            break
        }
        ipRow?.evaluateDisabled()
        portRow?.evaluateDisabled()
        passwordRow?.evaluateDisabled()
        cryptoRow?.evaluateDisabled()
        switchRow.updateCell()
        
        SSVPNManager.shared.ip_address = defaultStand?.string(forKey: SSUserConfig().ip) ?? ""
        SSVPNManager.shared.port = Int(defaultStand?.string(forKey: SSUserConfig().port) ?? "0")!
        SSVPNManager.shared.password = defaultStand?.string(forKey: SSUserConfig().password) ?? ""
        SSVPNManager.shared.algorithm = defaultStand?.string(forKey: SSUserConfig().algorithm) ?? ""
    }
    
    private func requestBaidu() {
        let url = URL(string: "https://m.baidu.com")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request).resume()
    }
}

extension ViewController {
    @objc private func onVPNStatusChanged() {
        self.status = SSVPNManager.shared.vpnStatus
    }
}
