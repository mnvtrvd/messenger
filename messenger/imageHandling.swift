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

        if selectedImg != nil {
            // imgForMsg.image = selectedImg
        }

        dismiss(animated: true, completion: nil)
    }
    
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
//            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
//            let asset = result.firstObject
//            print(asset?.value(forKey: "filename"))
//
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setImgBubbleFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        let image = UIImage(named: msg.data!)
        if msg.sender {
            cell.img.image = UIImage.setImgMsg(img: image!, x: 0, y: 0)
            cell.img.frame = CGRect(x: 20, y: 0, width: (cell.img.image?.size.width)!,
                                    height: (cell.img.image?.size.height)!)
            checkNext(cell: cell, indexPath: indexPath, isSender: true)
        } else {
            cell.img.image = UIImage.setImgMsg(img: image!, x: view.frame.width - screenWFrac - 15, y: 0)
            cell.img.frame = CGRect(x: view.frame.width - screenWFrac - 15, y: 0,
                                    width: (cell.img.image?.size.width)!,
                                    height: (cell.img.image?.size.height)!)
            checkNext(cell: cell, indexPath: indexPath, isSender: false)
        }
        
        setDetailsFrame(cell: cell, frame: cell.bubble.frame, sender: msg.sender)
    }
    
    func setLikeFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        let image = UIImage(named: "like")
        cell.img.layer.cornerRadius = 0
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
        let image = UIImage(named: msg.data!)
        if msg.sender {
            let resized = UIImage.setImgMsg(img: image!, x: 0, y: 0)
            return CGRect(x: 20, y: 0, width: resized.size.width, height: resized.size.height)
        } else {
            let resized = UIImage.setImgMsg(img: image!, x: view.frame.width - screenWFrac - 15, y: 0)
            return CGRect(x: view.frame.width - screenWFrac - 15, y: 0, width: resized.size.width, height: resized.size.height)
        }
    }

    func sendImg(imgName: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let newMsg = friendsVC.newMsg(friend: friend!, data: imgName, minutesAgo: 0, sender: false, type: "IMG", context: context)
            msgs?.append(newMsg)
            let index = IndexPath(item: msgs!.count-1, section: 0)
            collectionView.insertItems(at: [index])
            collectionView.scrollToItem(at: index, at: .bottom, animated: true)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)

            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
}
