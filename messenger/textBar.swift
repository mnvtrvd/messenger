//
//  textBar.swift
//  messenger
//
//  Created by Manav Trivedi on 10/7/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit

extension msgsVC {
    func setTypeView() {
        typeView.addSubview(curLocButton)
        typeView.addSubview(cameraButton)
        typeView.addSubview(galleryButton)
        typeView.addSubview(textField)
        typeView.addSubview(emojiButton)
        typeView.addSubview(divider)
        typeView.addSubview(minimizeButton)
        
        adjustSize(expand: false)
    }
    
    func animationTriggers() {
        curLocButton.addTarget(self, action: #selector(locButtonClicked), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(camButtonClicked), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonClicked), for: .touchUpInside)
        minimizeButton.addTarget(self, action: #selector(minimizeButtonClicked), for: .touchUpInside)
        emojiButton.addTarget(self, action: #selector(emojiButtonClicked), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textFieldChanged), for: UIControl.Event.editingChanged)
    }
    
    @objc func locButtonClicked() {
        print("opening map view")
    }
    
    @objc func minimizeButtonClicked() {
        print("should be minimizing now")
        adjustSize(expand: false)
    }
    
    @objc func camButtonClicked() {
        print("opening the camera now")
    }
    
    @objc func galleryButtonClicked() {
        print("opening the gallery now")
//        gallery.allowsEditing = true
        gallery.sourceType = .photoLibrary
        gallery.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        adjustSize(expand: true)
    }
    
    @objc func emojiButtonClicked() {
        print("sending your emoji")
    }

    func adjustSize(expand: Bool) {
        if (expand) {
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.expandedConstraints()
            })
        } else {
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.minimizedConstraints()
            })
        }
    }
    
    func minimizedConstraints() {
        typeView.addSubview(curLocButton)
        typeView.addSubview(cameraButton)
        typeView.addSubview(galleryButton)
        self.minimizeButton.removeFromSuperview()
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.curLocButton)
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.cameraButton)
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.galleryButton)
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.textField)
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.emojiButton)
        self.typeView.addConstraintsWithFormat(hor: "H:|[v0]|", vert: "V:|[v0(1)]", views: self.divider)
        self.typeView.addConstraintsWithFormat(hor: "H:|-10-[v0(30)]-10-[v1(30)]-10-[v2(30)]-10-[v3]-10-[v4(30)]-10-|", vert: "",
                                               views: self.curLocButton, self.cameraButton, self.galleryButton, self.textField, self.emojiButton)
    }
    
    func expandedConstraints() {
        typeView.addSubview(minimizeButton)
        self.curLocButton.removeFromSuperview()
        self.cameraButton.removeFromSuperview()
        self.galleryButton.removeFromSuperview()
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.minimizeButton)
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.textField)
        self.typeView.addConstraintsWithFormat(hor: "", vert: "V:|-10-[v0(30)]-50-|", views: self.emojiButton)
        self.typeView.addConstraintsWithFormat(hor: "H:|[v0]|", vert: "V:|[v0(1)]", views: self.divider)
        self.typeView.addConstraintsWithFormat(hor: "H:|-10-[v0(30)]-10-[v1]-10-[v2(30)]-10-|", vert: "",
                                               views: self.minimizeButton, self.textField, self.emojiButton)
    }
}
