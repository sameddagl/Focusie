//
//  HomeViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    
    enum States {
        case focus
        case shortBreak
        case longBreak
    }
    
    private var focusTime: Double = 25
    private var shortBreakTime: Double = 5
    private var longBreakTime: Double = 15
    
    private var currentTime: TimeInterval!
    private var currentState: States = .focus
    private var counter = 0
    private var canStartTimer = true
    
    private var timer: Timer?
    
    func startTimer() {
        if canStartTimer {
            canStartTimer = false
            currentTime = focusTime
            guard timer == nil else { return }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
        else {
            continueTimer()
        }
    }
    
    func continueTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func endTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
        
        focusTime = 25
        shortBreakTime = 5
        longBreakTime = 15
        canStartTimer = true
    }
    
    @objc private func fireTimer() {
        self.currentTime -= 1
        checkNewState()
        
        let timeStr = self.convertToStr(time: self.currentTime)
        self.notify(.updateTimer(time: timeStr))
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
            setTimeForNewState()
        }
    }
    
    private func setTimeForNewState() {
        switch currentState {
        case .focus:
            currentTime = focusTime
        case .shortBreak:
            currentTime = shortBreakTime
        case .longBreak:
            currentTime = longBreakTime
        }
    }
    
    private func convertToStr(time: Double) -> (String, String) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.zeroFormattingBehavior = .pad
        
        let minutes = formatter.string(from: time)!
        
        formatter.allowedUnits = [.second]
        let seconds = formatter.string(from: time)!
        
        return (minutes, seconds)
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleWithOutput(output)
    }
    
    
    
}
