//
//  SoundSettingsContracts.swift
//  Focusie
//
//  Created by Samed Dağlı on 7.12.2022.
//

import Foundation

protocol SoundSettingsViewModelProtocol {
    var delegate: SoundSettingsViewModelDelegate? { get set }
    func load()
    func selectItem(at index: Int)
}

enum SoundSettingsOutput {
    case updateSounds(sounds: [String])
    case updateWith(sound: BGSounds)
}

protocol SoundSettingsViewModelDelegate: AnyObject {
    func handleOutput(output: SoundSettingsOutput)
}

protocol SoundSettingsUpdateDelegate: AnyObject {
    func didUpdateWithNewSound()
}
