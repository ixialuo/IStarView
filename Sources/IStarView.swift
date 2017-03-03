//
//  IStarView.swift
//  StarView
//
//  Created by XiaLuo on 2017/2/27.
//  Copyright © 2017年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

/**
 画单个的五角星，私有不对外公开
 */
private let th = CGFloat(M_PI)/180
private class ISingleStarView: UIView {
    
    private var radius: CGFloat = 0                     //画五角星所在圆的半径
    fileprivate var fillLightedColor: UIColor?          //五角星高亮时的颜色
    fileprivate var fillDefaultColor: UIColor?          //五角星默认时的颜色
    fileprivate var strokeColor: UIColor?               //五角星描边颜色(赋值时才展示描边，默认为空不展示)
    
    //设置五角星高亮状态的范围(0~1)
    fileprivate var value: CGFloat = 0 {
        didSet{
            value = value < 0 ? 0 : value > 1 ? 1 : value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initAttribute()
    }
    
    //MARK: - 初始化属性
    private func initAttribute() {
        let x = bounds.width/2
        let y = bounds.height/2
        radius = x < y ? x : y
        isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawStar(rect)
    }
    
    //MARK: - 画单个五角星
    private func drawStar(_ rect: CGRect) {
        
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


/**
 根据需求画所需的五角星样式，对外公开
 */
//MARK: - 五角星的展示形式
public enum FormOfStars {
    case whole      //整个星展示
    case half       //半个星展示
    case accurate   //精确展示
}

//MARK: - IStarView的代理方法，向外部展示评分
public protocol IStarViewDelegate {
    func iStarViewValueDidChange(_ iStarView: IStarView)
}

open class IStarView: UIView {
    
    open var numberOfStars: Int = 5                     //设置五角星个数
    open var spaceOfStars: CGFloat = 0                  //五角星间的间距
    open var fillLightedColor: UIColor?                 //五角星高亮时的颜色
    open var fillDefaultColor: UIColor?                 //五角星默认时的颜色
    open var strokeColor: UIColor?                      //五角星描边颜色(赋值时才展示描边，默认为空不展示)
    open var formOfStars: FormOfStars = .half           //展示五角星时的形式
    open var delegate: IStarViewDelegate?               //IStarViewDelegate的代理对象
    open var isEvaluated: Bool = false                  //是否允许评分，默认为false
    open var isCompleteStarOfEvaluation: Bool = true    //评分时是否允许不是整星，默认为true
    
    //设置五角星高亮状态的范围(0~1)
    open var value: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initAttribute()
    }
    
    //MARK: - 初始化属性
    private func initAttribute() {
        isOpaque = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        addGestureRecognizer(tap)
    }
    
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        let starWidth = (bounds.width-spaceOfStars*CGFloat(numberOfStars-1))/CGFloat(numberOfStars)
        for i in 0..<numberOfStars {
            let iSingleStar = ISingleStarView(frame: CGRect(x: CGFloat(i)*(starWidth+spaceOfStars), y: 0, width: starWidth, height: bounds.height))
            iSingleStar.fillLightedColor = fillLightedColor
            iSingleStar.fillDefaultColor = fillDefaultColor
            iSingleStar.strokeColor = strokeColor
            
            switch formOfStars {
            case .whole:
                iSingleStar.value = CGFloat(i+1) <= value*CGFloat(numberOfStars) ? 1 : i == Int(value*CGFloat(numberOfStars)) ? (value*CGFloat(numberOfStars)-CGFloat(Int(value*CGFloat(numberOfStars)))) > 0.5 ? 1 : 0 : 0
            case .half:
                iSingleStar.value = CGFloat(i+1) <= value*CGFloat(numberOfStars) ? 1 : i == Int(value*CGFloat(numberOfStars)) ? (value*CGFloat(numberOfStars)-CGFloat(Int(value*CGFloat(numberOfStars)))) > 0.25 ? 0.5 : 0 : 0
            case .accurate:
                iSingleStar.value = CGFloat(i+1) <= value*CGFloat(numberOfStars) ? 1 : i == Int(value*CGFloat(numberOfStars)) ? value*CGFloat(numberOfStars)-CGFloat(Int(value*CGFloat(numberOfStars))) : 0
            }
            
            addSubview(iSingleStar)
        }
        
    }
    
    //MARK: - 评分时的手势方法
    @objc private func tapGesture(sender: UIGestureRecognizer) {
        guard isEvaluated else {
            return
        }
        let tapPoint = sender.location(in: self)
        let offset = tapPoint.x
        let realStarScore = CGFloat(offset/(bounds.width/CGFloat(numberOfStars)))
        let starScore = isCompleteStarOfEvaluation ? ceilf(Float(realStarScore)) : Float(realStarScore)
        value = CGFloat(starScore)/CGFloat(numberOfStars)
        delegate?.iStarViewValueDidChange(self)
        setNeedsDisplay()
    }
    
}
