//
//  HomeVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import UIKit
import AVFoundation

final class HomeVC: UIViewController {
    private let stateView = FCStateView()
    private let minutesLabel = FCTimeLabel()
    private let secondsLabel = FCTimeLabel()
    private let actionButton = FCActionButton()
    private let stopButton = FCStopButton()
    private let settingsButton = UIButton()
    
    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layout()
        viewModel.updateInfos()
    }
    
    //MARK: - Start and pause timer
    @objc private func actionButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        actionButton.isSelected.toggle()
        stopButton.isHidden = false
        
        if actionButton.isSelected {
            viewModel.startTimer()
        }
        else {
            viewModel.pauseTimer()
        }
    }
    
    //MARK: - Stop Timer
    @objc private func stopButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        let alert = UIAlertController(title: "Stop this pomodoro", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.endTimer()
            self.actionButton.isSelected = false
            self.stopButton.isHidden = true
        }))
        present(alert, animated: true)
    }
    
    //MARK: - Navigate to settings
    @objc private func settingsButtonTapped() {
        viewModel.settingsTapped()
    }
}

//MARK: - Delegate methods
extension HomeVC: HomeViewModelDelegate {
    func handleWithOutput(_ output: HomeViewModelOutput) {
        switch output {
        case.updateInfos(let infos):
            self.minutesLabel.text = infos.minutes
            self.secondsLabel.text = infos.seconds
            self.stateView.set(with: infos.currentState)
        case .updateTimer(let time):
            self.minutesLabel.text = time.minutes
            self.secondsLabel.text = time.seconds
        case .updateState(let state):
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.stateView.set(with: state)
        }
    }
    
    func navigate(to route: HomeViewModelRoute) {
        switch route {
        case .settings(let viewModel):
            let vc = SettingsVCBuilder.make(viewModel: viewModel)
            present(vc, animated: true)
        }
    }
}

//MARK: - UI Related
extension HomeVC {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        configureStateView()
        configureButtons()
        configureSettingsButton()
        
        let timeStack = UIStackView(arrangedSubviews: [minutesLabel, secondsLabel])
        timeStack.spacing = -25
        timeStack.distribution = .fill
        timeStack.axis = .vertical
        timeStack.alignment = .center
        
        let buttonsStack = UIStackView(arrangedSubviews: [actionButton , stopButton])
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [stateView, timeStack, buttonsStack])
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.heightAnchor.constraint(equalToConstant: 400),
        ])
    }
        
    private func configureStateView() {
        stateView.backgroundColor = .systemGreen
        
        NSLayoutConstraint.activate([
            stateView.heightAnchor.constraint(equalToConstant: 40),
            stateView.widthAnchor.constraint(equalToConstant: 130),
        ])
    }

    
    private func configureButtons() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        stopButton.isHidden = true
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: 60),
            actionButton.heightAnchor.constraint(equalToConstant: 60),
            stopButton.widthAnchor.constraint(equalToConstant: 60),
            stopButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
        
    private func configureSettingsButton() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsButton)
        
        settingsButton.setBackgroundImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        settingsButton.tintColor = .label
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 25),
            settingsButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
