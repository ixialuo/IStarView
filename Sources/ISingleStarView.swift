//
//  ISingleStarView.swift
//  StarView
//
//  Created by XiaLuo on 2017/3/1.
//  Copyright © 2017年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

private let th = CGFloat(M_PI)/180

class ISingleStarView: UIView {
    
    private var radius: CGFloat = 0
    var fillLightedColor: UIColor?
    var fillDefaultColor: UIColor?
    var strokeColor: UIColor?
    var value: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initAttribute()
    }
    
    //MARK: - 初始化属性
    func initAttribute() {
        let x = bounds.width/2
        let y = bounds.height/2
        radius = x < y ? x : y
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawStar(rect)
    }
    
    //MARK: - 画星星
    func drawStar(_ rect: CGRect) {
        
        let centerX = rect.width/2
        let centerY = rect.height/2
        let r0 = radius*sin(18*th)/cos(36*th)
        var x1: [CGFloat] = [0,0,0,0,0], y1: [CGFloat] = [0,0,0,0,0], x2: [CGFloat] = [0,0,0,0,0], y2: [CGFloat] = [0,0,0,0,0]
        
        for i in 0...4 {
            x1[i] = centerX+radius*cos((90+CGFloat(i)*72)*th)
            y1[i] = centerY-radius*sin((90+CGFloat(i)*72)*th)
            x2[i] = centerX+r0*cos((54+CGFloat(i)*72)*th)
            y2[i] = centerY-r0*sin((54+CGFloat(i)*72)*th)
        }
        
        let context = UIGraphicsGetCurrentContext()
        let startPath = CGMutablePath()
        
        startPath.move(to: CGPoint(x: x1[0], y: y1[0]))
        for i in 1...4 {
            startPath.addLine(to: CGPoint(x: x2[i], y: y2[i]))
            startPath.addLine(to: CGPoint(x: x1[i], y: y1[i]))
        }
        startPath.addLine(to: CGPoint(x: x2[0], y: y2[0]))
        startPath.closeSubpath()
        context?.addPath(startPath)
        
        let lightedRange = CGRect(x: x1[1], y: 0, width: (x1[4] - x1[1])*value, height: y1[2])
        context?.clip()
        context?.setFillColor((fillLightedColor ?? UIColor.yellow).cgColor)
        context?.fill(lightedRange)

        let defaultRange = CGRect(x: (x1[4] - x1[1])*value+x1[1], y: 0, width: (x1[4] - x1[1])*(1-value), height: y1[2])
        context?.setFillColor((fillDefaultColor ?? UIColor.groupTableViewBackground).cgColor)
        context?.fill(defaultRange)
        
        if let aStrokeColor = strokeColor {
            context?.addPath(startPath)
            context?.setStrokeColor(aStrokeColor.cgColor)
            context?.strokePath()
        }
        
    }

}
