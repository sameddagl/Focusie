//
//  SettingsViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation

final class SettingsViewModel: SettingsViewModelProtocol {
    weak var delegate: SettingsViewModelDelegate?
    
    private var persistanceManager: PersistanceManagerProtocol!
    
    init(persistanceManager: PersistanceManagerProtocol ,canChangeValues: Bool) {
        self.persistanceManager = persistanceManager
        self.canChangeValues = canChangeValues
    }
    
    private var focusTime: Double = 25
    private var shortBreakTime: Double = 5
    private var longBreakTime: Double = 15
    
    private let canChangeValues: Bool!
    
    func load() {
        getSavedValues()
        
        notify(.updateInitialInfos(times: (focusTime: Float(self.focusTime), shortBreakTime: Float(self.shortBreakTime), longBreakTime:Float(self.longBreakTime), areSlidersEnabled: canChangeValues)))
    }
    
    func focusTimeChanged(sliderValue: Float) {
        let step: Float = 1
        let roundedValue = round(sliderValue / step) * step
        self.focusTime = Double(roundedValue)
        
        notify(.focusTimeChanged(changedValue: roundedValue))
    }
    
    func shortBreakTimeChanged(sliderValue: Float) {
        let step: Float = 1
        let roundedValue = round(sliderValue / step) * step
        self.shortBreakTime = Double(roundedValue)
        
        notify(.shortBreakTimeChanged(changedValue: roundedValue))
    }
    
    func longBreakTimeChanged(sliderValue: Float) {
        let step: Float = 1
        let roundedValue = round(sliderValue / step) * step
        self.longBreakTime = Double(roundedValue)
        
        notify(.longBreakTimeChanged(changedValue: roundedValue))
    }
    
    func updateTimes() {
        if canChangeValues {
            saveToDefaults()
            notify(.updateTimesOnMainScreen)
        }
    }
    
    func contactUsTapped() {
        notify(.openMail)
    }
    
    func reviewTapped() {
        guard let url = URLs.productURL else { return }
        var compoments = URLComponents(url: url, resolvingAgainstBaseURL: false)
        compoments?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = compoments?.url else { return }
        notify(.openProductPage(url: writeReviewURL))
    }
    
    func shareTapped() {
        guard let url = URLs.productURL else { return }
        notify(.openSharePage(url: url))
    }
    
    private func saveToDefaults() {
        persistanceManager.save(focusTime: self.focusTime, shortBreakTime: self.shortBreakTime, longBreakTime: self.longBreakTime)
    }
    
    private func getSavedValues() {
        guard let focusTime = persistanceManager.retrieveData(forKey: Keys.focusTime) else { return }
        guard let shortBreakTime = persistanceManager.retrieveData(forKey: Keys.shortBreakTime) else { return }
        guard let longBreakTime = persistanceManager.retrieveData(forKey: Keys.longBreakTime) else { return }
        
        self.focusTime = focusTime
        self.shortBreakTime = shortBreakTime
        self.longBreakTime = longBreakTime
    }

    private func notify(_ output: SettingsOutput) {
        delegate?.handleWithOutput(output)
    }
}
