//
//  HomeVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import UIKit
import AVFoundation
import GoogleMobileAds

final class HomeVC: UIViewController {
    //MARK: - UI Properties
    private let stateView = FCStateView()
    private let minutesLabel = FCTimeLabel()
    private let secondsLabel = FCTimeLabel()
    private let actionButton = FCActionButton()
    private let stopButton = FCStopButton()
    private let settingsButton = UIButton()
    private let soundSettingsButton = UIButton()
    
    private var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?
    
    //MARK: - Properties
    var viewModel: HomeViewModelProtocol!
    
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
            loadInterstitialAdd()
            viewModel.pauseTimer()
        }
    }
    
    //MARK: - Stop Timer
    @objc private func stopButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        let alert = UIAlertController(title: "end_pomodoro".localized(), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel))
        alert.addAction(UIAlertAction(title: "yes".localized(), style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.restartPomodoro()
        }))
        present(alert, animated: true)
    }
    
    private func restartPomodoro() {
        view.isUserInteractionEnabled = false
        viewModel.endTimer()
        actionButton.isSelected = false
        stopButton.isHidden = true
        
        loadInterstitialAdd()
    }
    
    //MARK: - Navigate to settings
    @objc private func settingsButtonTapped() {
        viewModel.settingsTapped()
    }
    
    @objc private func soundSettingsButtonTapped() {
        viewModel.soundSettingsTapped()
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
        case .settings(let canChangeValues):
            let vc = SettingsVCBuilder.make(delegate:self, canChangeValues: canChangeValues)
            present(vc, animated: true)
        case .soundSettings:
            let vc = SoundSettingsBuilder.make(rootVC: self)
            present(vc, animated: true)
        }
    }
}

//MARK: - Update times that set on settings
extension HomeVC: SettingsUpdateDelegate {
    func didUpdateWithTimes() {
        viewModel.didUpdateWithTimes()
    }
}

extension HomeVC: SoundSettingsUpdateDelegate {
    func didUpdateWithNewSound() {
        viewModel.didBGSoundChanged()
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
        configureSoundSettingsButton()
        configureBanner()
        
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
        
        settingsButton.setBackgroundImage(SFSymbols.settings, for: .normal)
        settingsButton.tintColor = .label
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 25),
            settingsButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureSoundSettingsButton() {
        soundSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(soundSettingsButton)
        
        soundSettingsButton.setBackgroundImage(SFSymbols.soundsSettings, for: .normal)
        soundSettingsButton.tintColor = .label
        
        soundSettingsButton.addTarget(self, action: #selector(soundSettingsButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            soundSettingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            soundSettingsButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -20),
            soundSettingsButton.widthAnchor.constraint(equalToConstant: 25),
            soundSettingsButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureBanner() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
        bannerView.adUnitID = AddMobKeys.testBannerID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    private func loadInterstitialAdd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AddMobKeys.testInterstitialID, request: request) { [weak self] ad, error in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true
            guard error == nil else { return }
            self.interstitial = ad
            
            if self.interstitial != nil {
                self.interstitial!.present(fromRootViewController: self)
            }
        }
    }
}

//MARK: - Banner adds delegate
extension HomeVC: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            bannerView.alpha = 1
        })
    }
}
