//
//  HomeContracts.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func startTimer()
    func stopTimer()
    func endTimer()
}

enum HomeViewModelRoute {
    case settings
}

enum HomeViewModelOutput {
    case stopTimer
    case endTimer
    case updateTimer(time: (minutes: String, seconds: String))
}

protocol HomeViewModelDelegate: AnyObject {
    func handleWithOutput(_ output: HomeViewModelOutput)
    func navigate(to route: HomeViewModelRoute)
    
}
