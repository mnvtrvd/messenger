//
//  messageCell.swift
//  messenger
//
//  Created by Manav Trivedi on 10/7/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

class msgCell: cvCell {
    let msg: UITextView = {
        let textView = UITextView()
        textView.font = font16
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    let bubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let bubbleTrail: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setupViews() {
        addSubview(bubble)
        addSubview(bubbleTrail)
        addSubview(msg)
    }
}
