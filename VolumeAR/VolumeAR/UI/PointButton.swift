//
//  PointButton.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit

final class PointButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        setTitle("Set Point", for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        backgroundColor = UIColor.systemBlue
        tintColor = .white
        layer.cornerRadius = 8
    }
}
