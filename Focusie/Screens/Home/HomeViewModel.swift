//
//  HomeViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import Foundation

enum States: String {
    case focus = "Focus"
    case shortBreak = "Break"
    case longBreak = "Long Break"
}

final class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    
    private var persistanceManager: PersistanceManagerProtocol!
    private var audioPlayer: AudioManagerProtocol!
    
    init(persistanceManager: PersistanceManager, audioPlayer: AudioManagerProtocol?) {
        self.persistanceManager = persistanceManager
        self.audioPlayer = audioPlayer
    }
    
    private var focusTime: Double = 25
    private var shortBreakTime: Double = 5
    private var longBreakTime: Double = 15
    private let selectedBGSound: BGSound = .pianoBackground

    private var currentTime: TimeInterval!
    private var currentState: States = .focus
    private var counter = 0
    private var canStartTimer = true
    
    private var timer: Timer?
    
    func updateInfos() {
        setSavedValues()
        
        let time: (String, String) = convertToStr(time: focusTime * 60)
        notify(.updateInfos(infos: (minutes: time.0, seconds: time.1, currentState: currentState)))
    }
    
    func startTimer() {
        if canStartTimer {
            canStartTimer = false
            currentTime = focusTime * 60
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
        else {
            continueTimer()
        }
        
        audioPlayer.playBackgroundSound(with: selectedBGSound)
    }
    
    private func continueTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        
        audioPlayer.pausePlayingBackgroundSound()
    }
    
    func endTimer() {
        timer?.invalidate()
        timer = nil
        canStartTimer = true
        
        updateInfos()
        audioPlayer.endPlayingBackgroundSound()
        audioPlayer.stopPlayingOneTimeSound()
    }
    
    @objc private func fireTimer() {
        self.currentTime -= 1
        checkNewState()
        
        let timeStr = self.convertToStr(time: self.currentTime)
        self.notify(.updateTimer(time: timeStr))
    }
    
    func settingsTapped() {
        delegate?.navigate(to: .settings(viewModel: SettingsViewModel(persistanceManager: app.persistanceManager, canChangeValues: canStartTimer)))
    }
    
    func setNewTimes(focusTime: Double, breakTime: Double) {
        self.focusTime = focusTime
        self.shortBreakTime = breakTime
        updateInfos()
    }
    
    private func setSavedValues() {
        guard let focusTime = persistanceManager.retrieveData(forKey: Keys.focusTime) else { return }
        guard let shortBreakTime = persistanceManager.retrieveData(forKey: Keys.shortBreakTime) else { return }
        
        self.focusTime = focusTime
        self.shortBreakTime = shortBreakTime
    }

    private func checkNewState() {
        if currentTime < 0 {
            counter += 1
            
            if counter == 8 {
                counter = 0
                currentState = .longBreak
            }
            else if counter % 2 == 0 {
                currentState = .focus
            }
            else if counter % 2 != 0 {
                currentState = .shortBreak
            }
            updateState()
        }
    }
    
    private func updateState() {
        switch currentState {
        case .focus:
            currentTime = focusTime * 60
        case .shortBreak:
            currentTime = shortBreakTime * 60
        case .longBreak:
            currentTime = longBreakTime * 60
        }
        audioPlayer.playOneTimeSound()
        notify(.updateState(state: currentState))
    }
    
    private func convertToStr(time: Double) -> (String, String) {
        let minutes = String(format: "%02d", Int(time) / 60)
        let seconds = String(format: "%02d", Int(time) % 60)
    
        return (minutes, seconds)
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleWithOutput(output)
    }
}
