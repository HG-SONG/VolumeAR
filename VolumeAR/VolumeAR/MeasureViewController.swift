//
//  MeasureViewController.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit

final class MeasureViewController: UIViewController {
    private let reticleView = ReticleView()
    private let pointButton = UIButton(type: .system)
    private let joystickView = JoystickView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        setupReticleView()
        setupPointButton()
        setupJoystickView()
    }
    
    private func setupReticleView() {
        reticleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reticleView)
        NSLayoutConstraint.activate([
            reticleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reticleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reticleView.widthAnchor.constraint(equalToConstant: 30),
            reticleView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setupPointButton() {
        pointButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pointButton)
        pointButton.applyPointButtonStyle()
        NSLayoutConstraint.activate([
            pointButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            pointButton.widthAnchor.constraint(equalToConstant: 120),
            pointButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func setupJoystickView() {
        joystickView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(joystickView)
        NSLayoutConstraint.activate([
            joystickView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            joystickView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            joystickView.widthAnchor.constraint(equalToConstant: 60),
            joystickView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
