//
//  GYBanner.swift
//
//
//  Created by GuYi on 16/9/28.
//  Copyright © 2016年 aicai. All rights reserved.
//

import UIKit

let BannerTimeInterval = 2.0

protocol GYBannerDelegate {
    func clickBannerAtIndex(_ index:Int)
}

class GYBanner: UIView {
    
    override init(frame: CGRect ) {
        imageArray = [""]
        indexOfCurrentImage = 0
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, imageArray:[String]) {
        self.init(frame: frame)
        
        self.imageArray = imageArray
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not ben implemented")
    }
    
    var imageArray: [String]{
        willSet(newValue) {
            self.imageArray = newValue
        }
        didSet {
            contentScrollView.isScrollEnabled = !(imageArray.count == 1)
            self.pageIndicator.frame = CGRect(x: 0, y: self.frame.size.height - 20, width: 20 * CGFloat(imageArray.count), height: 20)
            self.pageIndicator.center.x = self.center.x
            self.pageIndicator.numberOfPages = self.imageArray.count
            self.setScrollViewOfImage()
            if timer == nil && imageArray.count > 1{
                self.timer = Timer.scheduledTimer(timeInterval: BannerTimeInterval, target: self, selector: #selector(GYBanner.timerAction), userInfo: nil, repeats: true)
            }
            
        }
    }
    
    var delegate:GYBannerDelegate?
    
    lazy var contentScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        scrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: 0)
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = !(self.imageArray.count == 1)
        return scrollView
    }()
    
    lazy var pageIndicator: UIPageControl = {
        let pageIndicator = UIPageControl(frame: CGRect(x: 0, y: self.frame.size.height - 20, width: 20 * CGFloat(self.imageArray.count), height: 20))
        pageIndicator.center.x = self.center.x
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = self.imageArray.count
        pageIndicator.backgroundColor = UIColor.clear
        return pageIndicator
    }()
    
    var timer: Timer?
    
    lazy var imageTap:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(GYBanner.imageTapAction(_:)))
        return tap
    }()
    
    lazy var currentImageView: UIImageView = {
        let currentImageView = UIImageView()
        currentImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        currentImageView.isUserInteractionEnabled = true
        currentImageView.clipsToBounds = true
        return currentImageView
    }()
    
    lazy var lastImageView: UIImageView = {
        let lastImageView = UIImageView()
        lastImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        lastImageView.clipsToBounds = true
        return lastImageView
    }()
    
    lazy var nextImageView: UIImageView = {
        let nextImageView = UIImageView()
        nextImageView.frame = CGRect(x: self.frame.size.width * 2, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        nextImageView.clipsToBounds = true
        return nextImageView
    }()
    
    var indexOfCurrentImage: Int {
        didSet {
            self.pageIndicator.currentPage = indexOfCurrentImage
        }
    }
    
    //MARK: private method
    fileprivate func setupUI() {
        
        self.addSubview(contentScrollView)
        self.addSubview(pageIndicator)
        
        contentScrollView.addSubview(currentImageView)
        contentScrollView.addSubview(lastImageView)
        contentScrollView.addSubview(nextImageView)
        
        setScrollViewOfImage()
        
        currentImageView.addGestureRecognizer(imageTap)
        
        if imageArray.count > 1 {
            timer = Timer.scheduledTimer(timeInterval: BannerTimeInterval, target: self, selector: #selector(GYBanner.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func setScrollViewOfImage(){
        
        currentImageView.image = UIImage(named:(string:self.imageArray[indexOfCurrentImage]))
        nextImageView.image = UIImage(named:(string:self.imageArray[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]))
        lastImageView.image = UIImage(named:(string:self.imageArray[self.getLastImageIndex(indexOfCurrentImage:self.indexOfCurrentImage)]))
    }
    
    fileprivate func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.imageArray.count - 1
        }else{
            return tempIndex
        }
    }
    
    fileprivate func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.imageArray.count ? tempIndex : 0
    }
    
    //MARK:  event response
    func timerAction() {
        
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
    }
    
    func imageTapAction(_ tap: UITapGestureRecognizer) {
        self.delegate?.clickBannerAtIndex(indexOfCurrentImage)
    }
}

//MARK: UIScrollViewDelegate
extension GYBanner: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        
        self.setScrollViewOfImage()
        
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: BannerTimeInterval, target: self, selector: #selector(GYBanner.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(contentScrollView)
    }
    
}
