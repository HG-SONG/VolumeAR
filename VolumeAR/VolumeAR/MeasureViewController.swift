//
//  MeasureViewController.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit
import ARKit
import Combine

final class MeasureViewController: UIViewController {
    let cameraView = ARSCNView()
    let reticleView = ReticleView()
    let pointButton = UIButton(type: .system)
    let joystickView = JoystickView()
    let modeLabel = UILabel()
    let surfaceIndicatorNode = SurfaceIndicatorNode()
    let surfaceTracker: SurfaceTracker = .init() // 테스트할 필요성이 있으면, 프로토콜로 의존성 주입해서 쓰자
    
    private var mode: Mode = .searching {
        didSet {
            updateUI(for: mode)
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupCameraView()
        setupUI()
        bindSurfaceTracker()
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

// MARK: - About Binding
extension MeasureViewController {
    private func bindSurfaceTracker() {
        surfaceTracker.modePublisher
            .removeDuplicates()
            .sink { [weak self] newMode in
                Task { @MainActor in
                    self?.updateMode(newMode)
                }
            }
            .store(in: &cancellables)

        surfaceTracker.surfaceInfoPublisher
            .sink { [weak self] info in
                Task { @MainActor in
                    guard let self = self else { return }
                    guard let info = info else {
                        self.surfaceIndicatorNode.isHidden = true
                        return
                    }

                    let minScale: Float = 0.3
                    let maxScale: Float = 1.5
                    let maxDistance: Float = 2.0
                    let scale = max(minScale, maxScale - (info.distance / maxDistance) * (maxScale - minScale))

                    self.surfaceIndicatorNode.isHidden = false
                    self.surfaceIndicatorNode.updateTransform(
                        position: info.position,
                        normal: info.normal,
                        scale: scale
                    )
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func updateMode(_ mode: Mode) {
        self.mode = mode
    }
    
    private func cancelSubscriptions() {
        cancellables.removeAll()
    }
}

// MARK: - ARKit Setup
extension MeasureViewController {
    private func setupCameraView() {
        cameraView.scene.rootNode.addChildNode(surfaceIndicatorNode)
        cameraView.delegate = surfaceTracker
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
