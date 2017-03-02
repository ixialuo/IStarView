//
//  IStarView.swift
//  StarView
//
//  Created by XiaLuo on 2017/2/27.
//  Copyright © 2017年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

//MARK: - 星的展示形式
public enum FormOfStars {
    case whole      //整个星展示
    case half       //半个星展示
    case accurate   //精确展示
}

public protocol IStarViewDelegate {
    func iStarViewValueDidChange(_ iStarView: IStarView)
}

public class IStarView: UIView {
    
    public var numberOfStars: Int = 5
    public var spaceOfStars: CGFloat = 0
    public var fillLightedColor: UIColor?
    public var fillDefaultColor: UIColor?
    public var strokeColor: UIColor?
    public var formOfStars: FormOfStars = .half
    public var delegate: IStarViewDelegate?
    public var isEvaluated: Bool = false
    public var isCompleteStarOfEvaluation: Bool = false   //评分时是否允许不是整星，默认为false
    
    var value: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
 

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initAttribute()
    }
    
    //MARK: - 初始化属性
    func initAttribute() {
        isOpaque = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        addGestureRecognizer(tap)
    }
    
    
    override public func draw(_ rect: CGRect) {
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
    
    func tapGesture(sender: UIGestureRecognizer) {
        guard isEvaluated else {
            return
        }
        let tapPoint = sender.location(in: self)
        let offset = tapPoint.x
        let realStarScore = CGFloat(offset/(bounds.width/CGFloat(numberOfStars)))
        let starScore = isCompleteStarOfEvaluation ? Float(realStarScore) : ceilf(Float(realStarScore))
        value = CGFloat(starScore)/CGFloat(numberOfStars)
        delegate?.iStarViewValueDidChange(self)
        setNeedsDisplay()
    }
    
    
   
    

    
    
   
 

}
