//
//  ViewController.swift
//  Example
//
//  Created by GuYi on 16/9/28.
//  Copyright © 2016年 aicai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var _:GYBanner = {
            view.addSubview($0)
            return $0
        }(GYBanner(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200), imageArray: ["about-bg.jpg","contact-bg.jpg","home-bg.jpg"]))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

