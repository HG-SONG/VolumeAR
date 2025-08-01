//
//  MeasureViewController.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit
import ARKit

final class MeasureViewController: UIViewController {
    enum Mode {
        case searching
        case idle
    }
    
    let cameraView = ARSCNView()
    let reticleView = ReticleView()
    let pointButton = UIButton(type: .system)
    let joystickView = JoystickView()
    let modeLabel = UILabel()
    
    private var mode: Mode = .searching {
        didSet {
            updateUI(for: mode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupSceneView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraView.session.pause()
    }
    
    private func updateUI(for mode: Mode) {
        switch mode {
        case .searching:
            modeLabel.text = "Searching for Surface"
            modeLabel.textColor = .systemRed
            reticleView.updateColor(.systemRed)
            pointButton.isEnabled = false
        case .idle:
            modeLabel.text = "Idle"
            modeLabel.textColor = .systemGreen
            reticleView.updateColor(.systemGreen)
            pointButton.isEnabled = true
        }
    }
}

// MARK: - ARKit Setup
extension MeasureViewController {
    private func setupSceneView() {
        cameraView.delegate = self
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func startARSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        cameraView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - UI Setup
extension MeasureViewController {
    func setupUI() {
        setupReticleView()
        setupPointButton()
        setupJoystickView()
        setupModeLabel()
        
        view.bringSubviewToFront(reticleView)
        view.bringSubviewToFront(pointButton)
        view.bringSubviewToFront(joystickView)
    }
    
    func setupReticleView() {
        reticleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reticleView)
        NSLayoutConstraint.activate([
            reticleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reticleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reticleView.widthAnchor.constraint(equalToConstant: 10),
            reticleView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func setupPointButton() {
        pointButton.isEnabled = false
        pointButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pointButton)
        pointButton.applyPointButtonStyle()
        NSLayoutConstraint.activate([
            pointButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            pointButton.widthAnchor.constraint(equalToConstant: 120),
            pointButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupJoystickView() {
        joystickView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(joystickView)
        NSLayoutConstraint.activate([
            joystickView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            joystickView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            joystickView.widthAnchor.constraint(equalToConstant: 60),
            joystickView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupModeLabel() {
        modeLabel.applyModeLabelStyle(initialText: "Searching for Surface")
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeLabel)
        NSLayoutConstraint.activate([
            modeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            modeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            modeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

// MARK: - ARSCNViewDelegate
extension MeasureViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard mode == .searching, anchor is ARPlaneAnchor else { return }
        Task { @MainActor in
            self.mode = .idle
        }
    }
}
