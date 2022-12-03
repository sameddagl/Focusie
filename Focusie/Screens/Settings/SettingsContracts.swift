//
//  SettingsContracts.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation

protocol SettingsViewModelProtocol {
    var delegate: SettingsViewModelDelegate? { get set }
    func load()
    func focusTimeChanged(sliderValue: Float)
    func breakTimeChanged(sliderValue: Float)
    func bgSoundChanged()
    func updateTimes()
}

enum SettingsOutput {
    case updateInitialInfos(times: (focusTime: Float, breakTime: Float, areSlidersEnabled: Bool))
    case updateTimesOnMainScreen
    case focusTimeChanged(changedValue: Float)
    case breakTimeChanged(changedValue: Float)
    case bgSoundChanged
}

protocol SettingsViewModelDelegate: AnyObject {
    func handleWithOutput(_ output: SettingsOutput)
}

protocol SettingsUpdateDelegate: AnyObject {
    func didUpdateWithTimes()
}
