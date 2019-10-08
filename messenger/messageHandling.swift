//
//  messageHandling.swift
//  messenger
//
//  Created by Manav Trivedi on 10/8/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

extension msgsVC: UITextFieldDelegate {
    @objc func keyboardDetection(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let active = (notification.name == UIResponder.keyboardWillShowNotification)
            let inactive = (notification.name == UIResponder.keyboardWillHideNotification)

            if active {
                keyBoardPosition?.constant = -keyboardFrame!.height + 30
                adjustSize(expand: true)
            } else if inactive {
                // TODO: figure out why the keyboard only dismisses when you press on a collection view cell and not anywhere outside
                keyBoardPosition?.constant = 0
                adjustSize(expand: false)
            }

            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                let lastItem = NSIndexPath(item: self.msgs!.count - 1, section: 0) as IndexPath
                self.collectionView?.scrollToItem(at: lastItem, at: .bottom, animated: true)
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        sendMsg()
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("closing keyboard")
        textField.endEditing(true)
    }
    
    func sendMsg() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            if textField.text != nil && textField.text!.count > 0 {
                let newMsg = friendsVC.newMsg(friend: friend!, data: textField.text!, minutesAgo: 0, sender: false, context: context)
                msgs?.append(newMsg)
                let index = IndexPath(item: msgs!.count-1, section: 0)
                collectionView.insertItems(at: [index])
                collectionView.scrollToItem(at: index, at: .bottom, animated: true)
                collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
                textField.text = nil
                
                do {
                    // TODO: figure out why this message isn't being stored permenantly, once you go to friends screen, and return to same friend's messages, all the messages you wrote disappear
                    try(context.save())
                } catch let err {
                    print(err)
                }
            }
        }
    }
}
