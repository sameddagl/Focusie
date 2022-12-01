//
//  SettingsViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation

final class SettingsViewModel: SettingsViewModelProtocol {
    var delegate: SettingsViewModelDelegate?
    
    private var focusTime = 25
    private var breakTime = 5
    
    func load() {
        notify(.updateInitialInfos(times: (focusTime: self.focusTime, breakTime: self.breakTime)))
    }
    
    func focusTimeChanged() {
        
    }
    
    func breakTimeChanged() {
        
    }
    
    func bgSoundChanged() {
        
    }
    
    private func notify(_ output: SettingsOutput) {
        delegate?.handleWithOutput(output)
    }
    
    
}
