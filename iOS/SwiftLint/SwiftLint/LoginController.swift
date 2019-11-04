//
//  LoginController.swift
//  SwiftLint
//
//  Created by Ning Li on 2019/4/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var phoneTF: HighlightedTextField!
    @IBOutlet weak var passwordTF: HighlightedTextField!
    @IBOutlet weak var validationCodeTF: HighlightedTextField!
    @IBOutlet weak var countDownButton: CountDownButton!
    @IBOutlet weak var validationCodeView: UIView!
    @IBOutlet weak var passwordLoginButton: UIButton!
    @IBOutlet weak var validationCodeLoginButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTF.setSubfixImage(#imageLiteral(resourceName: "unvisiable_icon"), for: .normal)
        passwordTF.setSubfixImage(#imageLiteral(resourceName: "visiable_icon"), for: .selected)
        passwordTF.subfixButton.addTarget(self, action: #selector(changePasswordState(sender:)), for: .touchUpInside)
        countDownButton.disableBGColor = UIColor.hexColor(hex: 0x60A9FF, alpha: 0.4)
        
        loginButton.addGradientBackground(colors: [UIColor.hexColor(hex: 0x6DBEFA).cgColor,
                                                   UIColor.hexColor(hex: 0x2777C8).cgColor],
                                          size: CGSize(width: UIScreen.main.bounds.width - 60,
                                                       height: 44),
                                          cornerRadius: 8)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    /// 获取验证码
    @IBAction func getValidationCode(_ sender: CountDownButton) {
        sender.startCountDown(duration: 5)
    }
    
    /// 密码登录
    @IBAction func passwordLogin(sender: UIButton) {
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        sender.isSelected = true
        validationCodeLoginButton.isSelected = false
        validationCodeLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        validationCodeView.isHidden = true
        validationCodeTF.resignFirstResponder()
    }
    
    /// 验证码登录
    @IBAction func valifationCodeLogin(sender: UIButton) {
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        sender.isSelected = true
        passwordLoginButton.isSelected = false
        passwordLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        validationCodeView.isHidden = false
        passwordTF.resignFirstResponder()
    }
    
    /// 切换密码状态
    @objc private func changePasswordState(sender: UIButton) {
        passwordTF.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    /// 忘记密码
    @IBAction func forgetPassword() {
        navigationController?.pushViewController(ModifyPasswordController(), animated: true)
    }
}
