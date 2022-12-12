//
//  SoundSettingsViewModel.swift
//  Focusie
//
//  Created by Samed Dağlı on 7.12.2022.
//

enum BGSounds: String {
    case piano = "Piano"
    case forest = "Forest"
    case cafe = "Cafe"
}

import Foundation

final class SoundSettingsViewModel: SoundSettingsViewModelProtocol {
    weak var delegate: SoundSettingsViewModelDelegate?
    
    private var bgSounds: [BGSounds] = [.piano, .forest, .cafe]

    func load() {
        let stringBGSounds = bgSounds.map { $0.rawValue }
        delegate?.handleOutput(output: .updateSounds(sounds: stringBGSounds))
    }
    
    func selectItem(at index: Int) {
        delegate?.handleOutput(output: .updateWith(sound: bgSounds[index]))
    }
}
