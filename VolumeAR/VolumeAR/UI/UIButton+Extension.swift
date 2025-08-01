//
//  UIButton+Extension.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//


import UIKit

extension UIButton {
    func applyPointButtonStyle() {
        self.setTitle("Set Point", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.tintColor = .white
        self.backgroundColor = UIColor.systemBlue
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
