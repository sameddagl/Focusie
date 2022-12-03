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
    private var breakTime: Double = 5
    
    private let canChangeValues: Bool!
    
    func load() {
        getSavedValues()
        
        notify(.updateInitialInfos(times: (focusTime: Float(self.focusTime), breakTime: Float(self.breakTime), areSlidersEnabled: canChangeValues)))
    }
    
    func focusTimeChanged(sliderValue: Float) {
        let step: Float = 1
        let roundedValue = round(sliderValue / step) * step
        self.focusTime = Double(roundedValue)
        
        notify(.focusTimeChanged(changedValue: roundedValue))
    }
    
    func breakTimeChanged(sliderValue: Float) {
        let step: Float = 1
        let roundedValue = round(sliderValue / step) * step
        self.breakTime = Double(roundedValue)
        
        notify(.breakTimeChanged(changedValue: roundedValue))
    }
    
    func bgSoundChanged() {
        
    }
    
    func updateTimes() {
        if canChangeValues {
            saveToDefaults()
            notify(.updateTimesOnMainScreen)
        }
    }
    
    func saveToDefaults() {
        persistanceManager.save(focusTime: self.focusTime, shortBreakTime: self.breakTime)
    }
    
    private func getSavedValues() {
        guard let focusTime = persistanceManager.retrieveData(forKey: Keys.focusTime) else { return }
        guard let shortBreakTime = persistanceManager.retrieveData(forKey: Keys.shortBreakTime) else { return }
        
        self.focusTime = focusTime
        self.breakTime = shortBreakTime
    }

    private func notify(_ output: SettingsOutput) {
        delegate?.handleWithOutput(output)
    }
}
