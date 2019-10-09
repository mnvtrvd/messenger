//
//  messagesList.swift
//  messenger
//
//  Created by Manav Trivedi on 10/7/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

class msgsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var msgs: [Message]?
    var keyBoardPosition: NSLayoutConstraint?
    
    let gallery = UIImagePickerController()
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            msgs = friend?.message?.allObjects as? [Message]
            msgs = msgs?.sorted(by: {$0.time!.compare($1.time! as Date) == .orderedAscending})
        }
    }
    
    let typeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputBubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = bubbleGray
        view.layer.masksToBounds = true
        return view
    }()
    
    let textField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .clear
        view.placeholder = "Aa"
        view.font = font16
        view.textColor = .black
        return view
    }()
    
    let divider: UIView = {
        let div = UIView()
        div.backgroundColor = .darkGray
        div.translatesAutoresizingMaskIntoConstraints = true
        return div
    }()

    let curLocButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "location"), for: UIControl.State.normal)
        view.imageView?.image?.withTintColor(fbSky)
        view.imageView?.contentMode = .scaleAspectFill
        view.imageView?.layer.masksToBounds = true
        return view
    }()
    
    let cameraButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "camera"), for: UIControl.State.normal)
        view.isUserInteractionEnabled = true
        view.imageView?.image?.withTintColor(fbSky)
        view.imageView?.contentMode = .scaleAspectFill
        view.imageView?.layer.masksToBounds = true
        return view
    }()
    
    let galleryButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "gallery"), for: UIControl.State.normal)
        view.imageView?.image?.withTintColor(fbSky)
        view.imageView?.contentMode = .scaleAspectFill
        view.imageView?.layer.masksToBounds = true
        return view
    }()
    
    let emojiButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "like"), for: UIControl.State.normal)
        view.imageView?.contentMode = .scaleAspectFill
        view.imageView?.layer.masksToBounds = true
        return view
    }()
    
    let minimizeButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "arrow"), for: UIControl.State.normal)
        view.imageView?.contentMode = .scaleAspectFill
        view.imageView?.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(msgCell.self, forCellWithReuseIdentifier: cid)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        textField.delegate = self
        
        view.addSubview(typeView)
        view.addConstraintsWithFormat(hor: "H:|[v0]|", vert: "V:[v0(80)]", views: typeView)
        setTypeView()
        animationTriggers()
        
        keyBoardPosition = NSLayoutConstraint(item: typeView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(keyBoardPosition!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDetection), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDetection), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = msgs?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cid, for: indexPath) as! msgCell
        
        cell.msg.text = msgs?[indexPath.item].data

//        if let imgName = msgs?[indexPath.item].friend?.profImg {

//            cell.imgName.image = UIImage(named: imgName)
        if let msg = msgs?[indexPath.item] {
            if msg.type == "MSG" {
                setBubbleFrame(msg: msg, cell: cell, indexPath: indexPath)
            } else if msg.type == "IMG" {
                setImgBubbleFrame(msg: msg, cell: cell, indexPath: indexPath)
            }
        }
        
        return cell
    }
    
    func setBubbleFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        let frame = estimateSize(msg: msg)
        
        if msg.sender {
            cell.bubble.frame = CGRect(x: 20, y: 0, width: frame.width + 30,
                                       height: frame.height + 20)
            checkNext(cell: cell, indexPath: indexPath, isSender: true)
        } else {
            cell.bubble.frame = CGRect(x: view.frame.width - frame.width - 15, y: 0,
                                       width: frame.width, height: frame.height + 20)
            checkNext(cell: cell, indexPath: indexPath, isSender: false)
        }

        setRelativeFrame(cell: cell, frame: cell.bubble.frame, sender: msg.sender)
    }
    
    func setImgBubbleFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        let image = UIImage(named: msg.data!)
        if msg.sender {
            cell.img.image = UIImage.setImgMsg(img: image!, x: 0, y: 0)
            cell.img.frame = CGRect(x: 20, y: 0, width: (cell.img.image?.size.width)!,
                                    height: (cell.img.image?.size.height)!)
            checkNext(cell: cell, indexPath: indexPath, isSender: true)
        } else {
            cell.img.image = UIImage.setImgMsg(img: image!, x: view.frame.width - screenW - 15, y: 0)
            cell.img.frame = CGRect(x: view.frame.width - screenW - 15, y: 0,
                                    width: (cell.img.image?.size.width)!,
                                    height: (cell.img.image?.size.height)!)
            checkNext(cell: cell, indexPath: indexPath, isSender: false)
        }
        
        setDetailsFrame(cell: cell, frame: cell.bubble.frame, sender: msg.sender)
    }
    
    func checkNext(cell: msgCell, indexPath: IndexPath, isSender: Bool) {
        if (msgs?.count ?? 0)-1 >= indexPath.item + 1 {
            if let next = msgs?[indexPath.item + 1] {
                if next.sender == isSender {
                    cell.bubbleTrail.isHidden = true
                }
            }
        }
    }
    
    func setRelativeFrame(cell: msgCell, frame: CGRect, sender: Bool) {
        cell.msg.frame = CGRect(x: frame.minX + 10, y: frame.minY, width: frame.width - 20, height: frame.height - 10)
        cell.bubble.backgroundColor = (sender) ? bubbleGray : fbSky
        cell.msg.textColor = (sender) ? .black : .white
        setDetailsFrame(cell: cell, frame: frame, sender: sender)
    }
    
    func setDetailsFrame(cell: msgCell, frame: CGRect, sender: Bool) {
        let trailX = (sender) ? frame.minX - 10 : frame.minX + frame.width
        cell.bubbleTrail.frame = CGRect(x: trailX, y: frame.height - 5, width: 10, height: 10)
        cell.bubbleTrail.backgroundColor = (sender) ? bubbleGray : fbSky
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let msg = msgs?[indexPath.item] {
            let frame = estimateSize(msg: msg)
            if (msg.type == "MSG") {
                return CGSize(width: view.frame.width, height: frame.height + 20)
            } else if (msg.type == "IMG") {
                return CGSize(width: view.frame.width, height: frame.height)
            }
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func estimateSize(msg: Message) -> CGRect {
        if msg.type == "MSG" {
            return NSString(string: msg.data!).boundingRect(with: CGSize(width: screenW, height: 1000),
                                                            options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                                            attributes: [NSAttributedString.Key.font: font16], context: nil)
        } else if msg.type == "IMG" {
            return getImgSize(msg: msg)
        }
        
        return CGRect()
    }
    
    func getImgSize(msg: Message) -> CGRect {
        let image = UIImage(named: msg.data!)
        if msg.sender {
            let resized = UIImage.setImgMsg(img: image!, x: 0, y: 0)
            return CGRect(x: 20, y: 0, width: resized.size.width, height: resized.size.height)
        } else {
            let resized = UIImage.setImgMsg(img: image!, x: view.frame.width - screenW - 15, y: 0)
            return CGRect(x: view.frame.width - screenW - 15, y: 0, width: resized.size.width, height: resized.size.height)
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
        
        let newH = (screenW/w)*h
        return img.resize(x: 0, y: 0, w: screenW, h: newH)
    }
}
