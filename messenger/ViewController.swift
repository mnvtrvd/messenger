//
//  ViewController.swift
//  messenger
//
//  Created by Manav Trivedi on 10/5/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

class friendsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var msgs: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chats"

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(friendCell.self, forCellWithReuseIdentifier: cid)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cid, for: indexPath) as! friendCell
        
        if let msg = msgs?[indexPath.item] {
            cell.msg = msg
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = msgs?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let msgList = msgsVC(collectionViewLayout: UICollectionViewFlowLayout())
        msgList.friend = msgs?[indexPath.item].friend
        msgs?[indexPath.item].read = true
        navigationController?.pushViewController(msgList, animated: true)
        print("User tapped on item \(indexPath.row)")
    }
}

class cvCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
    }
}
