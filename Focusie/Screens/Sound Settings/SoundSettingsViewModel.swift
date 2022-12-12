//
//  SoundSettingsViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 7.12.2022.
//

enum BGSounds: String {
    case none
    case piano = "pianoBackground"
    case forest = "forestBackground"
    case cafe = "cafeBackground"
}

import Foundation

final class SoundSettingsViewModel: SoundSettingsViewModelProtocol {
    weak var delegate: SoundSettingsViewModelDelegate?
    var persistanceManager: PersistanceManagerProtocol
    
    init(persistanceManager: PersistanceManagerProtocol) {
        self.persistanceManager = persistanceManager
    }
    
    private var bgSounds: [BGSound] = [
        BGSound(title: "None", isSelected: true),
        BGSound(title: "Piano", isSelected: false),
        BGSound(title: "Forest", isSelected: false),
        BGSound(title: "Cafe", isSelected: false),
    ]

    func load() {
        guard let selectedBG = persistanceManager.retrieveBGSound() else{
            bgSounds[0].isSelected = true
            delegate?.handleOutput(output: .updateSounds(sounds: bgSounds))
            return
        }
        
        for (index, _) in bgSounds.enumerated() {
            if bgSounds[index].sound.rawValue == selectedBG {
                bgSounds[index].isSelected = true
            }
            else {
                bgSounds[index].isSelected = false
            }
        }
        
        delegate?.handleOutput(output: .updateSounds(sounds: bgSounds))
    }
    
    func selectItem(at index: Int) {
        if !bgSounds[index].isSelected {
            for (index, _) in bgSounds.enumerated() {
                bgSounds[index].isSelected = false
            }
                        
            bgSounds[index].isSelected = true
            
            persistanceManager.saveBGSound(bgSound: bgSounds[index])
            delegate?.handleOutput(output: .updateWith)
            
            load()
        }
    }
}
