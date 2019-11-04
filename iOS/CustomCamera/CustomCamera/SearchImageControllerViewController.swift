//
//  SearchImageControllerViewController.swift
//  CustomCamera
//
//  Created by Ning Li on 2019/4/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class SearchImageControllerViewController: UIViewController {

    private lazy var image = UIImage()
    
    private lazy var placeholderImageView = UIImageView()
    
    private var imageView: TKImageView!
    
    private var timer: Timer?
    
    private var currentTime: Int = 0
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainScrollViewBottomCons: NSLayoutConstraint!
    
    class func instance(image: UIImage) -> SearchImageControllerViewController {
        let vc = SearchImageControllerViewController()
        vc.image = image
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderImageView.image = image
        mainScrollView.addSubview(placeholderImageView)
        placeholderImageView.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        
        let mask = UIView(frame: placeholderImageView.bounds)
        mask.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(mask)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.settingImageView()
            self.placeholderImageView.removeFromSuperview()
            mask.removeFromSuperview()
            
            self.mainScrollViewBottomCons.constant = 400
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragCollectionView(pan:)))
        mainCollectionView.addGestureRecognizer(pan)
        pan.delegate = self
    }
    
    @objc private func dragCollectionView(pan: UIPanGestureRecognizer) {
        let maxDistance = view.bounds.height - 80
        let offsetY = pan.translation(in: mainCollectionView).y
        if mainScrollViewBottomCons.constant >= maxDistance && offsetY <= 0 {
            mainScrollViewBottomCons.constant = maxDistance
            pan.setTranslation(CGPoint.zero, in: view)
            return
        } else if (mainScrollViewBottomCons.constant <= 100) && offsetY >= 0 {
            mainScrollViewBottomCons.constant = 100
            pan.setTranslation(CGPoint.zero, in: view)
            return
        }
        
        if mainCollectionView.contentOffset.y <= 0 || mainScrollViewBottomCons.constant >= maxDistance {
            mainScrollViewBottomCons.constant -= offsetY
            mainCollectionView.contentOffset = CGPoint.zero
        }
        pan.setTranslation(CGPoint.zero, in: view)
        
        switch pan.state {
        case .ended, .cancelled, .failed, .possible:
            if mainScrollViewBottomCons.constant <= (maxDistance + 100) * 0.5 {
                mainScrollViewBottomCons.constant = 100
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            } else {
                mainScrollViewBottomCons.constant = maxDistance
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    private func settingImageView() {
        let screenWidth = UIScreen.main.bounds.width
        let height = image.size.height * screenWidth / image.size.width
        let size = CGSize(width: screenWidth, height: height)
        print(size)
        imageView = TKImageView(frame: CGRect(origin: CGPoint(), size: size))
        imageView.toCropImage = image
        imageView.showMidLines = false
        imageView.needScaleCrop = false
        imageView.showCrossLines = false
        imageView.cornerBorderInImage = false
        imageView.cropAreaCornerWidth = 44
        imageView.cropAreaCornerHeight = 44
        imageView.minSpace = 30
        imageView.cropAreaCornerLineWidth = 3
        imageView.cropAreaCornerLineColor = UIColor.white
        imageView.cropAreaBorderLineWidth = 0
        imageView.cropAreaMidLineWidth = 0
        imageView.cropAreaMidLineHeight = 0
        imageView.cropAreaCrossLineWidth = 0
        imageView.maskColor = UIColor.black.withAlphaComponent(0.22)
        imageView.cropAspectRatio = 0
        imageView.delegate = self
        
        mainScrollView.addSubview(imageView)
        mainScrollView.contentSize = size
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.imageView.cropAspectRatio = 0
//        }
    }
    
    private func settingTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(calculateTime), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func calculateTime() {
        currentTime += 1
        if currentTime >= 4 {
            sendRequest()
            currentTime = 0
            invalidateTimer()
        }
    }
    
    private func sendRequest() {
        print("发送请求")
    }
}

// MARK: - TKImageViewDelegate
extension SearchImageControllerViewController: TKImageViewDelegate {
    func imageViewDidBeginChangeCropArea(_ imageView: TKImageView!) {
        invalidateTimer()
    }
    
    func imageViewDidEndChangeCropArea(_ imageView: TKImageView!) {
        settingTimer()
        print(imageView.currentCroppedImage())
    }
}

// MARK: - UIGestureRecognizerDelegate
extension SearchImageControllerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
