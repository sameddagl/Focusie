//
//  HomeContracts.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func setInitalInfos()
    func startTimer()
    func pauseTimer()
    func endTimer()
    func settingsTapped()
    func setNewTimes(focusTime: Double, breakTime: Double)
}

enum HomeViewModelRoute {
    case settings(viewModel: SettingsViewModelProtocol)
}

enum HomeViewModelOutput {
    case setInitialInfos(infos: (minutes: String, seconds: String, currentState: States))
    case endTimer
    case updateTimer(time: (minutes: String, seconds: String))
    case updateState(state: States)
}

protocol HomeViewModelDelegate: AnyObject {
    func handleWithOutput(_ output: HomeViewModelOutput)
    func navigate(to route: HomeViewModelRoute)
    
}

