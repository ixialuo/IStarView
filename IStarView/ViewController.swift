//
//  ViewController.swift
//  IStarView
//
//  Created by XiaLuo on 2017/3/1.
//  Copyright © 2017年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IStarViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let starView = IStarView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        starView.value = 0.8
        starView.center = view.center
        starView.fillLightedColor = UIColor.red
        starView.fillDefaultColor = UIColor.blue
        view.addSubview(starView)
    }
    
    func iStarViewValueDidChange(_ iStarView: IStarView) {
        print(iStarView.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

