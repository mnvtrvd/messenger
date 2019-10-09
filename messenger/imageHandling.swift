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
    
    func sendImg(img: UIImage) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let input = textField.text! + "        "
            let newMsg = friendsVC.newMsg(friend: friend!, data: input, minutesAgo: 0, sender: false, type: "IMG", context: context)
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
