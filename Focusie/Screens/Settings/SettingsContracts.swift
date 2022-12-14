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
    func shortBreakTimeChanged(sliderValue: Float)
    func longBreakTimeChanged(sliderValue: Float)
    func updateTimes()
    func contactUsTapped()
    func reviewTapped()
    func shareTapped()
}

enum SettingsOutput {
    case updateInitialInfos(times: (focusTime: Float, shortBreakTime: Float, longBreakTime: Float ,areSlidersEnabled: Bool))
    case updateTimesOnMainScreen
    case focusTimeChanged(changedValue: Float)
    case shortBreakTimeChanged(changedValue: Float)
    case longBreakTimeChanged(changedValue: Float)
    case openProductPage(url: URL)
    case openSharePage(url: URL)
    case openMail
}

protocol SettingsViewModelDelegate: AnyObject {
    func handleWithOutput(_ output: SettingsOutput)
}

protocol SettingsUpdateDelegate: AnyObject {
    func didUpdateWithTimes()
}
