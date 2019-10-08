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
    
    let textField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 15
        view.backgroundColor = bubbleGray
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        
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
            setBubbleFrame(msg: msg, cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    func setBubbleFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        let frame = estimateSize(msg: msg.data!)
        
        if msg.sender {
            cell.msg.frame = CGRect(x: 30, y: 0, width: frame.width + 20, height: frame.height + 20)
            cell.bubble.frame = CGRect(x: 20, y: 0, width: frame.width + 30, height: frame.height + 20)
            cell.bubbleTrail.frame = CGRect(x: 10, y: frame.height + 15, width: 10, height: 10)
            cell.bubble.backgroundColor = bubbleGray
            cell.bubbleTrail.backgroundColor = bubbleGray
            cell.msg.textColor = .black
            if (msgs?.count ?? 0)-1 >= indexPath.item + 1 {
                if let next = msgs?[indexPath.item + 1] {
                    if next.sender {
                        cell.bubbleTrail.isHidden = true
                    }
                }
            }
        } else {
            cell.msg.frame = CGRect(x: view.frame.width - frame.width - 10, y: 0, width: frame.width, height: frame.height + 20)
            cell.bubble.frame = CGRect(x: view.frame.width - frame.width - 15, y: 0, width: frame.width, height: frame.height + 20)
            cell.bubbleTrail.frame = CGRect(x: view.frame.width - 15, y: frame.height + 15, width: 10, height: 10)
            cell.bubble.backgroundColor = fbSky
            cell.bubbleTrail.backgroundColor = fbSky
            cell.msg.textColor = .white
            if (msgs?.count ?? 0)-1 >= indexPath.item + 1 {
                if let next = msgs?[indexPath.item + 1] {
                    if !next.sender {
                        cell.bubbleTrail.isHidden = true
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let msg = msgs?[indexPath.item].data {
            let frame = estimateSize(msg: msg)
            return CGSize(width: view.frame.width, height: frame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func estimateSize(msg: String) -> CGRect {
        return NSString(string: msg).boundingRect(with: CGSize(width: 250, height: 1000),
                                                  options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                                  attributes: [NSAttributedString.Key.font: font16], context: nil)
    }
}
