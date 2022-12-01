//
//  SettingsViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation

final class SettingsViewModel: SettingsViewModelProtocol {
    weak var delegate: SettingsViewModelDelegate?
    weak var updateDelegate: SettingsUpdateDelegate?
    
    private var focusTime: Double = 25
    private var breakTime: Double = 5
    
    
    func load() {
        notify(.updateInitialInfos(times: (focusTime: Float(self.focusTime), breakTime: Float(self.breakTime))))
    }
    
    func focusTimeChanged(sliderValue: Float) {
        let step: Float = 5
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
        updateDelegate?.didUpdateWithTimes(focusTime: self.focusTime, breakTime: self.breakTime)
    }
    
    private func notify(_ output: SettingsOutput) {
        delegate?.handleWithOutput(output)
    }
    
    
}
