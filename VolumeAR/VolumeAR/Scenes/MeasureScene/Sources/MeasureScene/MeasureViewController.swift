//
//  MeasureViewController.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit
import ARKit
import Combine
import VolumeUI
import VolumeEntities
import Protocols

public final class MeasureViewController: UIViewController {
    private let cameraView = ARSCNView()
    private let reticleView = ReticleView()
    private let pointButton = UIButton(type: .system)
    private let joystickView = JoystickView()
    private let modeLabel = UILabel()
    private let surfaceManager: SurfaceManagable
    private var surfaceTrackerCancellables = Set<AnyCancellable>()
    private var previewNode = PreviewSphereNode()
    
    private var mode: Mode = .searching {
        didSet {
            updateUI(for: mode)
        }
    }

    private let levelingManager: LevelingManagable
    private let levelBubble = LevelBubbleView()
    private var levelingCancellable: AnyCancellable?
    private let hapticManager: HapticManagable
    
    public init(surfaceManager: SurfaceManagable, levelingManager: LevelingManagable, hapticManager: HapticManagable) {
        self.surfaceManager = surfaceManager
        self.levelingManager = levelingManager
        self.hapticManager = hapticManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupCameraView()
        setupUI()
        bindSurfaceTracker()
        bindLeveling()
        levelingManager.start()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
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
        surfaceManager.modePublisher
            .removeDuplicates()
            .sink { [weak self] newMode in
                Task { @MainActor in
                    self?.updateMode(newMode)
                }
            }
            .store(in: &surfaceTrackerCancellables)
        
        surfaceManager.cameraTransformPublisher
            .sink { [weak self] camTransform in
                self?.levelingManager.updateCameraTransform(camTransform)
            }
            .store(in: &surfaceTrackerCancellables)
        
        surfaceManager.hitTestTransformPublisher
            .sink { [weak self] transform in
                Task { @MainActor in
                    guard let self = self else { return }
                    if let worldTransform = transform {
                        let position = SCNVector3(
                            worldTransform.columns.3.x,
                            worldTransform.columns.3.y,
                            worldTransform.columns.3.z
                        )
                        self.previewNode.update(position: position)
                        self.pointButton.isEnabled = true
                    } else {
                        self.previewNode.hide()
                        self.pointButton.isEnabled = false
                    }
                }
            }
            .store(in: &surfaceTrackerCancellables)
    }
    
    private func bindLeveling() {
        levelingCancellable = levelingManager.offsetPublisher
            .sink { [weak self] offset in
                Task { @MainActor in
                    self?.levelBubble.update(offset: offset, animated: true)
                    self?.hapticManager.impactIfNeeded(offset: offset.y)
                }
            }
        levelingCancellable?.store(in: &surfaceTrackerCancellables)
    }
    
    @MainActor
    private func updateMode(_ mode: Mode) {
        self.mode = mode
    }
    
    private func cancelSubscriptions() {
        surfaceTrackerCancellables.removeAll()
        levelingCancellable?.cancel()
    }
}

// MARK: - ARKit Setup
extension MeasureViewController {
    private func setupCameraView() {
        cameraView.delegate = surfaceManager
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        cameraView.scene.rootNode.addChildNode(previewNode)
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
        setupLevelBubble()
        
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
        modeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        modeLabel.applyModeLabelStyle(initialText: "Searching for Surface")
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeLabel)
        NSLayoutConstraint.activate([
            modeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            modeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            modeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupLevelBubble() {
        levelBubble.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelBubble)
        NSLayoutConstraint.activate([
            levelBubble.widthAnchor.constraint(equalToConstant: 15),
            levelBubble.heightAnchor.constraint(equalToConstant: 120),
            levelBubble.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelBubble.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
