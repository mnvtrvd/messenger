//
//  imageHandling.swift
//  messenger
//
//  Created by Manav Trivedi on 10/8/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension msgsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImg: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImg = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImg = originalImage
        }
        
        guard let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        if selectedImg != nil {
            let imgData:NSData = selectedImg!.pngData()! as NSData
            // PLEASE CHANGE THIS ASAP, THIS IS A HORRIBLE USE OF NSUSERDEFAULTS
            UserDefaults.standard.set(imgData, forKey: imgUrl.lastPathComponent)
            sendImg(imgName: imgUrl.lastPathComponent, inAssets: false)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setImgFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        var image = UIImage()
        if (msg.inAssets) {
            image = UIImage(named: msg.data!)!
        } else {
            // PLEASE CHANGE THIS ASAP, THIS IS A HORRIBLE USE OF NSUSERDEFAULTS
            let data = UserDefaults.standard.object(forKey: msg.data!) as! Data
            image = UIImage(data: data)!
        }
        cell.msg.isHidden = true
        cell.img.isHidden = false
        cell.bubble.isHidden = true
        cell.bubble.isHidden = false
        if msg.sender {
            cell.img.image = UIImage.setImgMsg(img: image, x: 0, y: 0)
            cell.img.frame = CGRect(x: 20, y: 0, width: (cell.img.image?.size.width)!,
                                    height: (cell.img.image?.size.height)!)
            checkNext(cell: cell, indexPath: indexPath, isSender: true)
        } else {
            cell.img.image = UIImage.setImgMsg(img: image, x: view.frame.width - screenWFrac - 15, y: 0)
            cell.img.frame = CGRect(x: view.frame.width - screenWFrac - 15, y: 0,
                                    width: (cell.img.image?.size.width)!,
                                    height: (cell.img.image?.size.height)!)
            checkNext(cell: cell, indexPath: indexPath, isSender: false)
        }
        
        // used for bubble trails, but it is kind of buggy, so i got rid of it temporarily
//        let frame = cell.img.frame
//        let trailX = (msg.sender) ? frame.minX - 10 : screenW - 15
//        cell.bubbleTrail.frame = CGRect(x: trailX, y: frame.height - 5, width: 10, height: 10)
//        cell.bubbleTrail.backgroundColor = (msg.sender) ? bubbleGray : fbSky
    }
    
    func setLikeFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        let image = UIImage(named: "like")
        cell.img.layer.cornerRadius = 0
        cell.msg.isHidden = true
        cell.img.isHidden = false
        cell.bubble.isHidden = true
        cell.bubble.isHidden = true
        if msg.sender {
            cell.img.image = UIImage.setImgMsg(img: image!, x: 0, y: 0)
            cell.img.frame = CGRect(x: 20, y: 0, width: emojiSize + 10, height: emojiSize + 20)
            checkNext(cell: cell, indexPath: indexPath, isSender: true)
        } else {
            cell.img.image = UIImage.setImgMsg(img: image!, x: CGFloat(screenW - CGFloat(emojiSize) - 15), y: 0)
            cell.img.frame = CGRect(x: Int(screenW) - emojiSize - 30, y: 0,
                                    width: emojiSize + 10, height: emojiSize + 20)
            checkNext(cell: cell, indexPath: indexPath, isSender: false)
        }
    }
    
    func estimateSize(msg: Message) -> CGRect {
        if msg.type == "MSG" {
            return NSString(string: msg.data!).boundingRect(with: CGSize(width: screenWFrac, height: 1000),
                                                            options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                                            attributes: [NSAttributedString.Key.font: font16], context: nil)
        } else if msg.type == "IMG" {
            return getImgSize(msg: msg)
        } else if msg.type == "EMOJI" {
            return CGRect(x: 0, y: 0, width: 0, height: emojiSize+10)
        } else if msg.type == "LIKE" {
            return CGRect(x: 0, y: 0, width: 0, height: emojiSize+20)
        }
        
        return CGRect()
    }
    
    func getImgSize(msg: Message) -> CGRect {
        var image = UIImage()
        if (msg.inAssets) {
            image = UIImage(named: msg.data!)!
        } else {
            let data = UserDefaults.standard.object(forKey: msg.data!) as! Data
            image = UIImage(data: data)!
        }
        if msg.sender {
            let resized = UIImage.setImgMsg(img: image, x: 0, y: 0)
            return CGRect(x: 20, y: 0, width: resized.size.width, height: resized.size.height)
        } else {
            let resized = UIImage.setImgMsg(img: image, x: view.frame.width - screenWFrac - 15, y: 0)
            return CGRect(x: view.frame.width - screenWFrac - 15, y: 0, width: resized.size.width, height: resized.size.height)
        }
    }

    func sendImg(imgName: String, inAssets: Bool = true) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let newMsg = friendsVC.newMsg(friend: friend!, data: imgName, minutesAgo: 0, sender: false, type: "IMG", inAssets: inAssets, context: context)
            msgs?.append(newMsg)
            scrollToBottom()

            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
}
