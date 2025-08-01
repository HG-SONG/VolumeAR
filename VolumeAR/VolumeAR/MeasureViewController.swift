//
//  Untitled.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit

final class MeasureViewController: UIViewController {
    private let reticleView = ReticleView()
    private let pointButton = PointButton()
    private let joystickView = JoystickView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        reticleView.translatesAutoresizingMaskIntoConstraints = false
        pointButton.translatesAutoresizingMaskIntoConstraints = false
        joystickView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(reticleView)
        view.addSubview(pointButton)
        view.addSubview(joystickView)
        
        NSLayoutConstraint.activate([
            // reticle 중앙
            reticleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reticleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reticleView.widthAnchor.constraint(equalToConstant: 30),
            reticleView.heightAnchor.constraint(equalToConstant: 30),
            
            // 점찍기 버튼 하단 중앙
            pointButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            pointButton.widthAnchor.constraint(equalToConstant: 120),
            pointButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 조이스틱 오른쪽 하단
            joystickView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            joystickView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            joystickView.widthAnchor.constraint(equalToConstant: 60),
            joystickView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
