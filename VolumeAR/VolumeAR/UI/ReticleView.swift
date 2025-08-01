//
//  ReticleView.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit

final class ReticleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    func updateColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }

    private func setupUI() {
        backgroundColor = .clear
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = bounds.width / 2
    }
}
