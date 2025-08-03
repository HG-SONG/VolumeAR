//
//  LevelBubbleView.swift
//  VolumeAR
//
//  Created by SONG on 8/2/25.
//

import UIKit
import VolumeEntities

public final class LevelBubbleView: UIView {
    private let bubbleSize: CGFloat = 10
    private let bubbleView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        v.layer.cornerRadius = 5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var maxRadius: CGFloat {
        return (bounds.height / 2) - (bubbleSize / 2)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }
    
    private func common() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        addSubview(bubbleView)
        NSLayoutConstraint.activate([
            bubbleView.widthAnchor.constraint(equalToConstant: bubbleSize),
            bubbleView.heightAnchor.constraint(equalToConstant: bubbleSize)
        ])
        bubbleView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if bubbleView.center == .zero {
            bubbleView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    public func update(offset: LevelOffset, animated: Bool = false) {
        let centerX = bounds.midX
        let dy = -CGFloat(offset.y) * maxRadius
        let target = CGPoint(x: centerX, y: bounds.midY + dy)
        
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.bubbleView.center = target
            }
        } else {
            bubbleView.center = target
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let cornerRadius = rect.height / 2
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius)
        UIColor.white.setStroke()
        path.lineWidth = 1
        path.stroke()
    }
}
