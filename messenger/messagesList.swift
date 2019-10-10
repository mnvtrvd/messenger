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
                setImgFrame(msg: msg, cell: cell, indexPath: indexPath)
            } else if msg.type == "EMOJI" {
                setEmojiFrame(cell: cell, msg: msg, indexPath: indexPath)
            } else if msg.type == "LIKE" {
                setLikeFrame(msg: msg, cell: cell, indexPath: indexPath)
            }
        }
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let msg = msgs?[indexPath.item] {
            let frame = estimateSize(msg: msg)
            if msg.type == "MSG" {
                return CGSize(width: view.frame.width, height: frame.height + 20)
            } else if msg.type == "IMG" {
                return CGSize(width: view.frame.width, height: frame.height)
            } else if msg.type == "EMOJI" {
                return CGSize(width: Int(screenW), height: emojiSize + 20)
            } else if msg.type == "LIKE" {
                return CGSize(width: Int(screenW), height: emojiSize + 20)
            }
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}
