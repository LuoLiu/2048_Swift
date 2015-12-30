//
//  OtherViews.swift
//  2048
//
//  Created by LuoLiu on 15/12/28.
//  Copyright © 2015年 fenrir_cd08. All rights reserved.
//

import UIKit

protocol ScoreViewProtocol {
    func scoreChanged(newScore s: Int)
}

class ScoreView: UIView, ScoreViewProtocol {
    var score: Int = 0 {
        didSet {
            label.text = "SCORE: \(score)"
        }
    }
    
    let defaultFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width-100, 60)
    var label: UILabel
    
    init(backgroundColor bgColor: UIColor, textColor: UIColor, font: UIFont, radius: CGFloat) {
        label = UILabel(frame: defaultFrame)
        label.textAlignment = NSTextAlignment.Center
        super.init(frame: defaultFrame)
        backgroundColor = bgColor
        label.textColor = textColor
        label.font = font
        layer.cornerRadius = radius
        self.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func scoreChanged(newScore s: Int) {
        score = s
    }
}

