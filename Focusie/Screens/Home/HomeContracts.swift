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
    func continueTimer()
    func pauseTimer()
    func endTimer()
}

enum HomeViewModelRoute {
    case settings
}

enum HomeViewModelOutput {
    case setInitialInfos(infos: (minutes: String, seconds: String, stateName:String, stateImageName: String))
    case stopTimer
    case endTimer
    case updateTimer(time: (minutes: String, seconds: String))
    case updateState(state: (title: String, imageName: String))
}

protocol HomeViewModelDelegate: AnyObject {
    func handleWithOutput(_ output: HomeViewModelOutput)
    func navigate(to route: HomeViewModelRoute)
    
}
