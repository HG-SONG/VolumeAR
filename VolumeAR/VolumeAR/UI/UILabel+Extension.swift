//
//  UILabel+Extension.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit

extension UILabel {
    func applyModeLabelStyle(initialText: String) {
        self.text = initialText
        self.alpha = 0.75
        self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.textColor = .systemRed
        self.textAlignment = .right
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
