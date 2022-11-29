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
    
    var focusTime: Double = 25
    var shortBreakTime: Double = 5
    var longBreakTime: Double = 15
    
    var currentTime: TimeInterval = 5
    var currentState: States = .focus
    var counter = 0

    var timer: Timer?
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func endTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
        
        focusTime = 25
        shortBreakTime = 5
        longBreakTime = 15
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
