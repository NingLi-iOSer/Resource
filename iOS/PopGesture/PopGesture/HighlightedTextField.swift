//
//  HighlightedTextField.swift
//  PopGesture
//
//  Created by Ning Li on 2019/3/30.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol HighlightedTextFieldDelegate: class {
    func textFieldDidBeginEditing(_ textField: HighlightedTextField)
    func textFieldDidEndEditing(_ textField: HighlightedTextField)
}

extension HighlightedTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: HighlightedTextField) { }
    func textFieldDidEndEditing(_ textField: HighlightedTextField) { }
}

class HighlightedTextField: UITextField {
    
    weak var textFieldDelegate: HighlightedTextFieldDelegate?
    
    @IBInspectable var prefixImage: UIImage? {
        didSet {
            prefixImageView.image = prefixImage
            prefixImageView.sizeToFit()
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 0 {
        didSet {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftInset, height: 1))
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightInset: CGFloat = 0 {
        didSet {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightInset, height: 1))
            rightViewMode = .always
        }
    }

    private lazy var prefixImageView = UIImageView()
    lazy var subfixButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        settingUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settingUI()
    }
    
    private func settingUI() {
        addSubview(prefixImageView)
        addSubview(subfixButton)
        prefixImageView.frame.origin.x = 22
        
        delegate = self
    }
    
    func setSubfixImage(_ image: UIImage?, for state: UIControl.State) {
        subfixButton.setImage(image, for: state)
        subfixButton.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageViewY = (bounds.height - prefixImageView.bounds.height) * 0.5
        prefixImageView.frame.origin.y = imageViewY
        subfixButton.frame.origin = CGPoint(x: bounds.width - 22 - subfixButton.bounds.width,
                                               y: imageViewY)
    }
}

extension HighlightedTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing(self)
        textField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        textField.layer.shadowOpacity = 0.25
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidEndEditing(self)
        textField.layer.shadowColor = UIColor.white.cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowOffset = CGSize()
    }
}
