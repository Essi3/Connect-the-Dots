//
//  ViewController.swift
//  Connect the dots
//
//  Created by Elisabeth Roozen on 2019-04-11.
//  Copyright © 2019 Elisabeth Roozen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DotViewDelegate, UIScrollViewDelegate {

    var selectedDot: DotView?
    var superScrollView: UIScrollView?
    var superContentView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        superScrollView = UIScrollView(frame: view.bounds)
        superScrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        superScrollView?.delegate = self
        let contentSize: CGFloat = 2000
        superScrollView?.contentSize = CGSize(width: contentSize, height: contentSize)
        superScrollView?.contentOffset = CGPoint(x: contentSize/2 - view.frame.size.width/2, y: contentSize/2 - view.frame.size.height/2)
        superScrollView?.minimumZoomScale = 0.5
        superScrollView?.maximumZoomScale = 2.0
        
        superContentView = UIView(frame: CGRect(x:0, y:0, width: contentSize, height: contentSize))
        superScrollView?.addSubview(superContentView!)
        view.addSubview(superContentView!)
        
        // Lägga till tap-gesture (skapa nya dots)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        superContentView!.addGestureRecognizer(tap)
    }

    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        
        // CGPoint och lägg till dot
        print("did tap")
        
        if selectedDot != nil {
            selectedDot?.deselect()
            selectedDot = nil
        } else {
            // X and Y coordinates
            let tapPoint = gesture.location(in: superContentView)
            let dot = DotView(tapPoint)
            dot.delegate = self
            superContentView!.addSubview(dot)
        }
    }
    
    //MARK: DotViewDelegate
    
    func didEdit(_ dot: DotView) {
        
        let textInput = UIAlertController(title: "Edit dot text", message: "", preferredStyle: .alert)
        textInput.addTextField { (textField) in
            textField.text = dot.label.text
        }
        textInput.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let textField = textInput.textFields![0] as UITextField
            dot.label.text = textField.text
        }))
        self.present(textInput, animated: true, completion: nil)
    }
    
    func didSelect(_ dot: DotView) {
        if selectedDot != nil {
            if dot == selectedDot {
                //delete bubbles
                dot.delete()
            } else {
                //TODO: connect bubbles
                let line = LineView(from: selectedDot!, to: dot)
                superContentView!.insertSubview(line, at: 0)
                selectedDot?.lines.append(line)
                dot.lines.append(line)
            }
            //Deselect sselectedDot
            selectedDot?.deselect()
            selectedDot = nil
        } else {
            selectedDot = dot
            selectedDot?.select()
        }
    }
    
    //MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return superContentView
        
    }
}

