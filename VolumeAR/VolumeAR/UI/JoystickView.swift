//
//  JoystickView.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit

final class JoystickView: UIView {
    private let baseView = UIView()
    private let handleView = UIView()

    private var handleCenterX: NSLayoutConstraint!
    private var handleCenterY: NSLayoutConstraint!
    private var baseCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startRotationAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        baseView.backgroundColor = UIColor.systemGray5
        baseView.layer.cornerRadius = 30
        baseView.layer.borderColor = UIColor.gray.cgColor
        baseView.layer.borderWidth = 1
        baseView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(baseView)
        NSLayoutConstraint.activate([
            baseView.widthAnchor.constraint(equalToConstant: 60),
            baseView.heightAnchor.constraint(equalToConstant: 60),
            baseView.centerXAnchor.constraint(equalTo: centerXAnchor),
            baseView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        handleView.backgroundColor = UIColor.systemBlue
        handleView.layer.cornerRadius = 15
        handleView.layer.shadowColor = UIColor.black.cgColor
        handleView.layer.shadowOpacity = 0.3
        handleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        handleView.layer.shadowRadius = 3
        handleView.translatesAutoresizingMaskIntoConstraints = false

        baseView.addSubview(handleView)
        handleCenterX = handleView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor)
        handleCenterY = handleView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor)

        NSLayoutConstraint.activate([
            handleCenterX,
            handleCenterY,
            handleView.widthAnchor.constraint(equalToConstant: 30),
            handleView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func startRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 5
        rotation.repeatCount = .infinity
        handleView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveHandle(with: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveHandle(with: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetHandlePosition()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetHandlePosition()
    }
    
    private func moveHandle(with touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: baseView)
        let maxRadius = baseView.bounds.width / 2
        
        let dx = location.x - maxRadius
        let dy = location.y - maxRadius
        let distance = sqrt(dx*dx + dy*dy)
        
        if distance <= maxRadius {
            handleCenterX.constant = dx
            handleCenterY.constant = dy
        } else {
            let ratio = maxRadius / distance
            handleCenterX.constant = dx * ratio
            handleCenterY.constant = dy * ratio
        }
        
        UIView.animate(withDuration: 0.1) {
            self.baseView.layoutIfNeeded()
        }
    }
    
    private func resetHandlePosition() {
        handleCenterX.constant = 0
        handleCenterY.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.baseView.layoutIfNeeded()
        }
    }
}
