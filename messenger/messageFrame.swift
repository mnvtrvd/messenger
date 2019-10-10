//
//  messagePlacement.swift
//  messenger
//
//  Created by Manav Trivedi on 10/9/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

extension msgsVC {
    func setBubbleFrame(msg: Message, cell: msgCell, indexPath: IndexPath) {
        cell.msg.isHidden = false
        cell.img.isHidden = true
        cell.bubble.isHidden = false
        cell.bubble.isHidden = false
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

    func setEmojiFrame(cell: msgCell, msg: Message, indexPath: IndexPath) {
        cell.msg.isHidden = false
        cell.img.isHidden = true
        cell.bubble.isHidden = true
        cell.bubble.isHidden = true
        cell.msg.font = font50
        if msg.sender {
            cell.msg.frame = CGRect(x: 10, y: 0, width: emojiSize*msg.data!.count + 10,
                                       height: emojiSize + 20)
            checkNext(cell: cell, indexPath: indexPath, isSender: true)
        } else {
            cell.msg.frame = CGRect(x: Int(screenW) - emojiSize*msg.data!.count - 20, y: 0,
                                       width: emojiSize*msg.data!.count + 10, height: emojiSize + 20)
            checkNext(cell: cell, indexPath: indexPath, isSender: false)
        }

        let frame = cell.msg.frame
        let trailX = (msg.sender) ? frame.minX : frame.minX + frame.width - 5
        cell.bubbleTrail.frame = CGRect(x: trailX, y: frame.height - 5, width: 10, height: 10)
        cell.bubbleTrail.backgroundColor = (msg.sender) ? bubbleGray : fbSky
    }

    func checkNext(cell: msgCell, indexPath: IndexPath, isSender: Bool) {
        if (msgs?.count ?? 0)-1 >= indexPath.item + 1 {
            if let next = msgs?[indexPath.item + 1] {
                if next.sender == isSender && next.type != "EMOJI" {
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
}
