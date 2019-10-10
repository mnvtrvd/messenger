//
//  friendCell.swift
//  messenger
//
//  Created by Manav Trivedi on 10/7/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

class friendCell: cvCell {
    var msg: Message? {
        didSet {
            nameLabel.text = msg?.friend?.name
            if let profImg = msg?.friend?.profImg {
                profileImg.image = UIImage(named: profImg)
            }
            msgLabel.text = msg?.data
            if msg?.read ?? true {
                msgLabel.font = font14
                timeLabel.font = font14
                read.isHidden = true
            } else {
                msgLabel.font = bold14
                timeLabel.font = bold14
                read.isHidden = false
            }
            
            if let time = msg?.time {
                let dateFormatter = DateFormatter()
                
                let days = NSDate().timeIntervalSince(time as Date)
                
                if days > 365*day {
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                } else if days > 7*day {
                    dateFormatter.dateFormat = "MMM dd"
                } else if days > day {
                    dateFormatter.dateFormat = "EEE"
                } else {
                    dateFormatter.dateFormat = "h:mm a"
                }
                
                timeLabel.text = dateFormatter.string(from: time as Date)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? fbSky : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            msgLabel.textColor = isHighlighted ? .white : .darkGray
            timeLabel.textColor = isHighlighted ? .white : .black
        }
    }

    let profileImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = true
        img.layer.cornerRadius = 35
        img.layer.masksToBounds = true
        return img
    }()

    func newProfImg() {
        addSubview(profileImg)
        addConstraintsWithFormat(hor: "H:|-10-[v0(70)]|", vert: "V:[v0(70)]", views: profileImg)
        addConstraint(NSLayoutConstraint(item: profileImg, attribute: .centerY,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .centerY, multiplier: 1, constant: 0))
    }

    let divider: UIView = {
        let div = UIView()
        div.translatesAutoresizingMaskIntoConstraints = true
        div.backgroundColor = .darkGray
        return div
    }()

    func newDivider() {
        addSubview(divider)
        addConstraintsWithFormat(hor: "H:|-10-[v0]-10-|", vert: "V:[v0(1)]", views: divider)
        addConstraint(NSLayoutConstraint(item: divider, attribute: .bottom,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .bottom, multiplier: 1, constant: 0))
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = bold18
        return label
    }()

    func newName(view: UIView) {
        view.addSubview(nameLabel)
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .top, multiplier: 1, constant: 0))
        view.addConstraintsWithFormat(hor: "H:|[v0]|", vert: "V:|[v0]|", views: nameLabel)
    }

    let msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    func newMsg(view: UIView) {
        view.addSubview(msgLabel)
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: .bottom,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .bottom, multiplier: 1, constant: 0))
        
//        if (msgLabel.text?.count > 32) {
//            view.addConstraintsWithFormat(hor: "H:|[v0(230)]-10-[v1(80)]", vert: "V:|[v0]|", views: msgLabel, timeLabel)
//        } else {
            view.addConstraintsWithFormat(hor: "H:|[v0]-10-[v1(80)]|", vert: "V:|[v0]|", views: msgLabel, timeLabel)
//        }
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = font14
        label.textAlignment = .right
        return label
    }()
    
    func newTime(view: UIView) {
        view.addSubview(timeLabel)
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .bottom,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraintsWithFormat(hor: "", vert: "V:|[v0]|", views: timeLabel)
    }
    
    let read: UIView = {
        let read = UIView()
        read.backgroundColor = fbSky
        read.contentMode = .scaleAspectFill
        read.layer.cornerRadius = 35
        read.layer.masksToBounds = true
        return read
    }()
    
    func newRead() {
        addSubview(read)
        read.translatesAutoresizingMaskIntoConstraints = true
        addConstraintsWithFormat(hor: "H:|-10-[v0(70)]|", vert: "V:[v0(70)]", views: read)
        addConstraint(NSLayoutConstraint(item: read, attribute: .centerY,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .centerY, multiplier: 1, constant: 0))
        pulse(obj: read)
    }
    
    func newInfo() {
        let info = UIView()
        addSubview(info)
        addConstraintsWithFormat(hor: "H:|-90-[v0]-10-|", vert: "V:[v0(50)]", views: info)
        addConstraint(NSLayoutConstraint(item: info, attribute: .centerY,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .centerY, multiplier: 1, constant: 0))
        newRead()
        newName(view: info)
        newTime(view: info)
        newMsg(view: info)
    }
    
    override func setupViews() {
        newDivider()
        newInfo()
        newProfImg()
    }
}
