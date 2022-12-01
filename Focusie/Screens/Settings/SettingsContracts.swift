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
    func focusTimeChanged()
    func breakTimeChanged()
    func bgSoundChanged()
}

enum SettingsOutput {
    case updateInitialInfos(times: (focusTime: Int, breakTime: Int))
    case focusTimeChanged
    case breakTimeChanged
    case bgSoundChanged
}

protocol SettingsViewModelDelegate {
    func handleWithOutput(_ output: SettingsOutput)
}
