//
//  DotView.swift
//  Connect the dots
//
//  Created by Elisabeth Roozen on 2019-04-11.
//  Copyright © 2019 Elisabeth Roozen. All rights reserved.
//

import UIKit

protocol DotViewDelegate {
    func didSelect(_ dot: DotView)
    func didEdit(_ dot: DotView)
}

class DotView: UIView {
    
    var lines = [LineView]()
    var delegate: DotViewDelegate?
    var color: UIColor?
    var label = UILabel()

    // MARK: Init
    init(_ atPoint: CGPoint) {
        
        let size: CGFloat = 80
        let frame = CGRect(x: atPoint.x - size/2, y: atPoint.y - size/2, width: size, height: size)
        super.init(frame: frame)
        backgroundColor = UIColor.randomColor()
        layer.cornerRadius = size/2
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanInDot(_:)))
        addGestureRecognizer(pan)
        
        let doubleTap = UITapGestureRecognizer(target: self, action:  #selector(didDoubleTapinDot(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action:  #selector(didTapinDot(_:)))
        tap.require(toFail: doubleTap)
        addGestureRecognizer(tap)
        
        label.frame = bounds
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "Text"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(label)
        
    }
    
    //MARK: Gestures
    
    @objc func didPanInDot(_ gesture: UIPanGestureRecognizer) {
        print("did end pan")
        if gesture.state == .changed {
            self.center = gesture.location(in: superview)
            for line in lines {
                line.update()
            }
        } else if gesture.state == .began {
            superview?.bringSubviewToFront(self)
        } else if gesture.state == .ended {
            print("did end pan")
        }
        
    }
    
    @objc func didTapinDot(_ gesture: UITapGestureRecognizer) {
        print("did tap")
        guard let dot = gesture.view as? DotView else {
            return
        }
        if delegate != nil{
            delegate!.didSelect(dot)
        }
    }
    
    @objc func didDoubleTapinDot(_ gesture: UITapGestureRecognizer) {
        print("did tap")
        guard let dot = gesture.view as? DotView else {
            return
        }
        if delegate != nil{
            delegate!.didEdit(dot)
        }
    }
    
    func select() {
        color = backgroundColor
        backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
    
    func deselect() {
        backgroundColor = color
    }
    
    func delete() {
        for line in lines {
            line.removeFromSuperview()
        }
       removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Draw
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func randomSizeDot() -> CGFloat {
        
        let size = CGFloat(arc4random_uniform(150)) / 2
         return CGFloat(size)
    }
   
    
}

extension UIColor {
    
    static func randomColor() -> UIColor {
        
        let randomRed = CGFloat(arc4random_uniform(250)) / 255.0
        let randomGreen = CGFloat(arc4random_uniform(250)) / 255.0
        let randomBlue = CGFloat(arc4random_uniform(250)) / 255.0
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

