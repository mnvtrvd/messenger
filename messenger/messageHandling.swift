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
                let lastItem = IndexPath(item: self.msgs!.count - 1, section: 0)
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
            let data = textField.text
            
            if data != nil && data!.count > 0 {
                if data!.count <= 1 && data!.containsOnlyEmoji {
                    let newMsg = friendsVC.newMsg(friend: friend!, data: data!, sender: false, type: "EMOJI", context: context)
                    msgs?.append(newMsg)
                } else if data == "sim" {
                    let newMsg = friendsVC.simulate(friend: friend!, context: context)
                    msgs?.append(newMsg)
                } else {
                    let input = data! + "        "
                    let newMsg = friendsVC.newMsg(friend: friend!, data: input, sender: false, context: context)
                    msgs?.append(newMsg)
                }
                scrollToBottom()
                textField.text = nil

                do {
                    try context.save()
                } catch let err {
                    print(err)
                }
            }
        }
    }
    
    func sendLike() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let newMsg = friendsVC.newMsg(friend: friend!, data: "like", minutesAgo: 0, sender: false, type: "LIKE", context: context)
            msgs?.append(newMsg)
            scrollToBottom()

            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    
    func scrollToBottom() {
        let index = IndexPath(item: msgs!.count-1, section: 0)
        collectionView.insertItems(at: [index])
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
        
        // second way of calling this, may help fix small ui bug
//        let lastItem = IndexPath(item: self.msgs!.count - 1, section: 0)
//        self.collectionView?.scrollToItem(at: lastItem, at: .bottom, animated: true)
    }
}
