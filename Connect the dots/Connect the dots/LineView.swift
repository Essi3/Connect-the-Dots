//
//  LineView.swift
//  Connect the dots
//
//  Created by Elisabeth Roozen on 2019-04-11.
//  Copyright © 2019 Elisabeth Roozen. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    var fromView: DotView?
    var toView: DotView?
    
    init(from: DotView, to: DotView) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        fromView = from
        toView = to
        update()
        
    }
    
    func update() {
        
        //TODO: beräkna ny frame och påkalla ny utritning
        if fromView != nil && toView != nil {
            self.frame = fromView!.frame.union(toView!.frame)
                //.insetBy(dx: fromView!.frame.size.width / 2, dy: fromView!.frame.size.height / 2)
            self.setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath()
        path.move(to: fromView!.center - frame.origin) //Startpoint
        path.addLine(to: toView!.center - frame.origin) //End point
        path.lineWidth = 1.0
        UIColor.randomColor().setStroke()
        path.stroke()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }

}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
