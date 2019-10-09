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

extension UIImage {
    func resize(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> UIImage {
        let targetSize = CGSize.init(width: w, height: h)
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            let location = CGPoint.init(x: x, y: y)
            self.draw(in: CGRect(origin: location, size: targetSize))
        }
    }
    
    static func setImgMsg(img: UIImage, x: CGFloat, y: CGFloat) -> UIImage {
        let w = img.size.width
        let h = img.size.height
        
        let newH = (screenWFrac/w)*h
        return img.resize(x: 0, y: 0, w: screenWFrac, h: newH)
    }
}

// emoji detection found on stack overflow
extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
             0x1F300...0x1F5FF, // Misc Symbols and Pictographs
             0x1F680...0x1F6FF, // Transport and Map
             0x1F1E6...0x1F1FF, // Regional country flags
             0x2600...0x26FF, // Misc symbols
             0x2700...0x27BF, // Dingbats
             0xE0020...0xE007F, // Tags
             0xFE00...0xFE0F, // Variation Selectors
             0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
             0x1F018...0x1F270, // Various asian characters
             0x238C...0x2454, // Misc items
             0x20D0...0x20FF: // Combining Diacritical Marks for Symbols
            return true

        default: return false
        }
    }

    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

// emoji detection found on stack overflow
extension String {
    var containsOnlyEmoji: Bool {
        return !isEmpty && !unicodeScalars.contains(where: {
            !$0.isEmoji && !$0.isZeroWidthJoiner
        })
    }
}
