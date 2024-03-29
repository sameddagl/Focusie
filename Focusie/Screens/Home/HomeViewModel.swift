//
//  HomeViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import Foundation

enum States: String {
    case focus = "focus_title"
    case shortBreak = "short_break_title"
    case longBreak = "long_break_title"
    
    func getLocalizedString() ->String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

final class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    
    //MARK: - Injections
    private var persistanceManager: PersistanceManagerProtocol!
    private var audioPlayer: AudioManagerProtocol!
    private var notificationManager: LocalNotificationManagerProtocol!
    
    init(persistanceManager: PersistanceManager, audioPlayer: AudioManagerProtocol, notificationManager: LocalNotificationManagerProtocol) {
        self.persistanceManager = persistanceManager
        self.audioPlayer = audioPlayer
        self.notificationManager = notificationManager
    }
    
    //MARK: - Properties
    private var focusTime: Double = 25
    private var shortBreakTime: Double = 5
    private var longBreakTime: Double = 15
    private var selectedBGSound: BGSounds = .none

    private var currentTime: TimeInterval!
    private var currentState: States = .focus
    private var breakCounter = 0
    private var canStartTimer = true
    
    private var timer: Timer?
    
    //MARK: - Main Functions
    func updateInfos() {
        setSavedValues()
        
        let time: (String, String) = convertToStr(time: focusTime * 60)
        notify(.updateInfos(infos: (minutes: time.0, seconds: time.1, currentState: currentState)))
    }
    
    func didUpdateWithTimes() {
        updateInfos()
    }
    
    func didBGSoundChanged() {
        setBGSound()
        if !canStartTimer {
            audioPlayer.endPlayingBackgroundSound()
            audioPlayer.playBackgroundSound(with: selectedBGSound)
        }
    }
    
    //MARK: - Timer Functions
    func startTimer() {
        if canStartTimer {
            canStartTimer = false
            currentTime = focusTime * 60
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        audioPlayer.playBackgroundSound(with: selectedBGSound)
    }
    
    @objc private func fireTimer() {
        self.currentTime -= 1
        checkNewState()
        
        let timeStr = self.convertToStr(time: self.currentTime)
        self.notify(.updateTimer(time: timeStr))
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        
        audioPlayer.pauseBackgroundSound()
    }
    
    func endTimer() {
        timer?.invalidate()
        timer = nil
        
        canStartTimer = true
        currentState = .focus
        breakCounter = 0
        
        updateInfos()
        audioPlayer.endPlayingBackgroundSound()
        audioPlayer.stopPlayingOneTimeSound()
    }
    
    //MARK: - Button Actions
    func settingsTapped() {
        delegate?.navigate(to: .settings(canChangeValues: canStartTimer))
    }
    
    func soundSettingsTapped() {
        delegate?.navigate(to: .soundSettings)
    }
    
    //MARK: - Persistance Functions
    private func setSavedValues() {
        setBGSound()

        guard let focusTime = persistanceManager.retrieveData(forKey: Keys.focusTime) else { return }
        guard let shortBreakTime = persistanceManager.retrieveData(forKey: Keys.shortBreakTime) else { return }
        guard let longBreakTime = persistanceManager.retrieveData(forKey: Keys.longBreakTime) else { return }
        
        self.focusTime = focusTime
        self.shortBreakTime = shortBreakTime
        self.longBreakTime = longBreakTime
    }
    
    private func setBGSound() {
        guard let bgSound = persistanceManager.retrieveBGSound() else { return }
        self.selectedBGSound = BGSounds(rawValue: bgSound)!
    }

    //MARK: - Check States
    private func checkNewState() {
        if currentTime < 0 {
            breakCounter += 1
            
            if breakCounter == 7 {
                breakCounter = -1
                currentState = .longBreak
            }
            
            else if breakCounter % 2 == 0 {
                currentState = .focus
            }
            else if breakCounter % 2 != 0 {
                currentState = .shortBreak
            }
            updateState()
        }
    }
    
    private func updateState() {
        switch currentState {
        case .focus:
            currentTime = focusTime * 60
            notificationManager.setNotification(1, of: .seconds, repeats: false, title: "focus_time_title".localized(), body: "focus_time_body".localized(), userInfo: nil)
        case .shortBreak:
            currentTime = shortBreakTime * 60
            notificationManager.setNotification(1, of: .seconds, repeats: false, title: "break_time_title".localized(), body: "break_time_body".localized(), userInfo: nil)
        case .longBreak:
            currentTime = longBreakTime * 60
            notificationManager.setNotification(1, of: .seconds, repeats: false, title: "break_time_title".localized(), body: "break_time_body".localized(), userInfo: nil)
        }
        
        audioPlayer.playOneTimeSound()
        notify(.updateState(state: currentState))
    }
    
    //MARK: - Helper Functions
    private func convertToStr(time: Double) -> (String, String) {
        let minutes = String(format: "%02d", Int(time) / 60)
        let seconds = String(format: "%02d", Int(time) % 60)
    
        return (minutes, seconds)
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleWithOutput(output)
    }
}
