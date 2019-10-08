//
//  UIViewExt.swift
//  messenger
//
//  Created by Manav Trivedi on 10/7/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func newTextView(font: UIFont, color: UIColor) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.backgroundColor = color
        return textView
    }
    
    func addConstraintsWithFormat(hor: String, vert: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if hor != "" {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hor,
                                                          options: NSLayoutConstraint.FormatOptions(),
                                                          metrics: nil, views: viewsDictionary))
        }
        if vert != "" {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vert,
                                                          options: NSLayoutConstraint.FormatOptions(),
                                                          metrics: nil, views: viewsDictionary))
        }
    }
    
    func pulse(obj: UIView) {
        UIView.animate(withDuration: 0.8, delay: 0, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat],
                       animations: {
            obj.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    // fades an object in or out depending on current opacity
    func fade(objs: UIView..., duration: Double) {
        for obj in objs {
            if obj.alpha == 0 {
                UIView.animate(withDuration: duration, animations: { obj.alpha = 1 })
            } else {
                UIView.animate(withDuration: duration, animations: { obj.alpha = 0 })
            }
        }
    }
    
    // bounce animation in provided direction for a given object
    func bounce(objs: UIView..., up: CGFloat, left: CGFloat) {
        for obj in objs {
            let curX = obj.frame.origin.x
            let curY = obj.frame.origin.y
            let curW = obj.frame.size.width
            let curH = obj.frame.size.height
        
            UIView.animate(withDuration: 0.15, animations: {
                obj.frame = CGRect(x: curX-left, y: curY-up,
                                   width: curW, height: curH)
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.15, animations: {
                    obj.frame = CGRect(x: curX, y: curY,
                                       width: curW, height: curH)
                })
            })
        }
    }
    
    // translates an object on the screen
    func translate(objs: UIView..., up: CGFloat, left: CGFloat) {
        for obj in objs {
            let curX = obj.frame.origin.x
            let curY = obj.frame.origin.y
            let curW = obj.frame.size.width
            let curH = obj.frame.size.height
            
            obj.frame = CGRect(x: curX-left, y: curY-up,
                               width: curW, height: curH)
        }
    }
}
