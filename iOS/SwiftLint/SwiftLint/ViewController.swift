//
//  ViewController.swift
//  SwiftLint
//
//  Created by Ning Li on 2019/4/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var navViewBGLayer = CAGradientLayer()
    private lazy var headerRectLayer = CAGradientLayer()
    private lazy var headerArcLayer = CAGradientLayer()
    private lazy var shapeLayer = CAShapeLayer()
    
    private var headerBackgroundHeight: CGFloat {
        return view.bounds.height * 0.25
    }
    
    private lazy var images = [UIImage(contentsOfFile: Bundle.main.path(forResource: "image_0", ofType: "jpg")!),
                               UIImage(contentsOfFile: Bundle.main.path(forResource: "image_1", ofType: "jpg")!),
                               UIImage(contentsOfFile: Bundle.main.path(forResource: "image_2", ofType: "jpg")!),
                               UIImage(contentsOfFile: Bundle.main.path(forResource: "image_3", ofType: "jpg")!)]
    
    private weak var timer: DispatchSourceTimer?
    
    @IBOutlet weak var loopView: UICollectionView!
    @IBOutlet weak var loopViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var loopViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var navViewHeightCons: NSLayoutConstraint!
    /// 导航条
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navButton1: UIButton!
    @IBOutlet weak var navButton2: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 1)
        
        navViewHeightCons.constant = UIApplication.shared.statusBarFrame.height + 56

        settingNavViewBackground()
        settingHeaderBackground(headerY: navViewHeightCons.constant, offset: 27)
        
        navViewBGLayer.colors = [UIColor.hexColor(hex: 0x4398F6).cgColor,
                                 UIColor.hexColor(hex: 0x2777C8).cgColor]
        navViewBGLayer.startPoint = CGPoint(x: 0, y: 0.5)
        navViewBGLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        headerRectLayer.colors = [UIColor.hexColor(hex: 0x4398F6).cgColor,
                                 UIColor.hexColor(hex: 0x2777C8).cgColor]
        headerRectLayer.startPoint = CGPoint(x: 0, y: 0.5)
        headerRectLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        headerArcLayer.colors = [UIColor.hexColor(hex: 0x4398F6).cgColor,
                                 UIColor.hexColor(hex: 0x2777C8).cgColor]
        headerArcLayer.startPoint = CGPoint(x: 0, y: 0.5)
        headerArcLayer.endPoint = CGPoint(x: 1, y: 0.5)

        headerArcLayer.mask = shapeLayer
        view.layer.insertSublayer(headerRectLayer, at: 0)
        view.layer.insertSublayer(headerArcLayer, at: 0)
        
        loopViewWidthCons.constant = view.bounds.width
        
        loopViewLayout.itemSize = CGSize(width: view.bounds.width - 30, height: 120)
        loopViewLayout.scrollDirection = .horizontal
        loopViewLayout.minimumLineSpacing = 30
        loopViewLayout.sectionInset.left = 15
        loopViewLayout.sectionInset.right = 15
        
        loopView.register(UINib(nibName: "MSLoopViewCell", bundle: nil), forCellWithReuseIdentifier: "cellId")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if timer == nil {
            settingTimer()

            loopView.scrollToItem(at: IndexPath(item: images.count, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            timer?.resume()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.suspend()
    }
    
    deinit {
        timer?.cancel()
    }
    
    private func settingTimer() {
        timer = GCDTimer.makeTimer(duration: DispatchTimeInterval.seconds(3), delay: DispatchTime.now() + 3, queue: DispatchQueue.main, event: { [weak self] (_) in
            self?.updateLoopView()
        })
    }
    
    private func settingNavViewBackground() {
        navViewBGLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.bounds.width, height: navViewHeightCons.constant))
        navView.layer.insertSublayer(navViewBGLayer, at: 1)
    }
    
    private func settingHeaderBackground(headerY: CGFloat, offset: CGFloat) {
        let rectHeight = headerBackgroundHeight - 27 - navViewHeightCons.constant
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        headerRectLayer.frame = CGRect(x: 0, y: headerY, width: view.bounds.width, height: rectHeight)
        settingArcBackground(offset: offset)
        CATransaction.commit()
    }
    
    private func settingArcBackground(offset: CGFloat) {
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        let controlPoint = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: offset)
        
        let path = UIBezierPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        shapeLayer.path = path.cgPath
        
        headerArcLayer.frame = CGRect(x: 0, y: headerRectLayer.frame.maxY - 0.5, width: view.bounds.width, height: offset)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    private func settingNormalState() {
        settingHeaderBackground(headerY: navViewHeightCons.constant, offset: 27)
        headerArcLayer.opacity = 1.0
        headerRectLayer.opacity = 1.0
        navViewBGLayer.opacity = 1.0
        titleLabel.textColor = UIColor.white
        navButton1.setImage(#imageLiteral(resourceName: "nav_create_white"), for: .normal)
        navButton2.setImage(#imageLiteral(resourceName: "nav_back_white"), for: .normal)
        titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    private func settingHighlightedState() {
        let loopViewMaxY = mainScrollView.convert(loopView.frame, to: view).maxY
        settingHeaderBackground(headerY: loopViewMaxY - headerBackgroundHeight + 27 + navViewHeightCons.constant, offset: 0)
        headerArcLayer.opacity = 0
        headerRectLayer.opacity = 0
        navViewBGLayer.opacity = 0
        titleLabel.textColor = UIColor.hexColor(hex: 0x111111)
        navButton1.setImage(#imageLiteral(resourceName: "nav_create"), for: .normal)
        navButton2.setImage(#imageLiteral(resourceName: "nav_back"), for: .normal)
        titleLabel.transform = CGAffineTransform(scaleX: 5 / 6, y: 5 / 6)
    }
    
    private func updateBackground() {
        let loopViewMaxY = mainScrollView.convert(loopView.frame, to: view).maxY
        if loopViewMaxY > headerBackgroundHeight {
            settingNormalState()
        } else if loopViewMaxY <= headerBackgroundHeight && loopViewMaxY > (headerBackgroundHeight - 27) {
            settingHeaderBackground(headerY: navViewHeightCons.constant, offset: 27 - (headerBackgroundHeight - loopViewMaxY))
        } else if loopViewMaxY <= (headerBackgroundHeight - 27) && (loopViewMaxY > (UIApplication.shared.statusBarFrame.height + 44)) {
            let distance = loopViewMaxY - headerBackgroundHeight + 27
            settingHeaderBackground(headerY: loopViewMaxY - headerBackgroundHeight + 27 + navViewHeightCons.constant, offset: 0)
            
            let opacity = 1 - (-distance / (headerBackgroundHeight - 71 - UIApplication.shared.statusBarFrame.height))
            headerArcLayer.opacity = Float(opacity)
            headerRectLayer.opacity = Float(opacity)
            navViewBGLayer.opacity = Float(opacity)
            
            let scale = min((25 + 5 * opacity) / 30, 1)
            titleLabel.layer.transform = CATransform3DMakeScale(scale, scale, 1)
            
            navViewHeightCons.constant = UIApplication.shared.statusBarFrame.height + 44 + 12 * opacity
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            navViewBGLayer.frame.size.height = navViewHeightCons.constant
            CATransaction.commit()
            
            if opacity <= 0.3 {
                titleLabel.textColor = UIColor.hexColor(hex: 0x111111)
                navButton1.setImage(#imageLiteral(resourceName: "nav_create"), for: .normal)
                navButton2.setImage(#imageLiteral(resourceName: "nav_back"), for: .normal)
            } else {
                titleLabel.textColor = UIColor.white
                navButton1.setImage(#imageLiteral(resourceName: "nav_create_white"), for: .normal)
                navButton2.setImage(#imageLiteral(resourceName: "nav_back_white"), for: .normal)
            }
        } else {
            settingHighlightedState()
        }
    }
    
    /// 更新轮播图
    private func updateLoopView() {
        let index = loopView.indexPathsForVisibleItems.first!.item + 1
        loopView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            updateBackground()
            return
        }
        
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width) % images.count
        pageControl.currentPage = index
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            return
        }
        timer?.cancel()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == mainScrollView {
            return
        }
        settingTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            return
        }
        let page = loopView.indexPathsForVisibleItems.first!.item
        if page == 0 {
            loopView.scrollToItem(at: IndexPath(item: images.count, section: 0), at: .centeredHorizontally, animated: false)
        } else if page == (images.count * 2 - 1) {
            loopView.scrollToItem(at: IndexPath(item: images.count - 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MSLoopViewCell
        cell.imageView.image = images[indexPath.item % images.count]
        return cell
    }
}
