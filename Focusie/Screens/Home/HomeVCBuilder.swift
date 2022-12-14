//
//  HomeVCBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import Foundation

final class HomeVCBuilder {
    static func make() -> HomeVC {
        let vc = HomeVC()
        let viewModel = HomeViewModel(persistanceManager: app.persistanceManager, audioPlayer: app.audioManager, notificationManager: app.notificationManager)
        viewModel.delegate = vc
        vc.viewModel = viewModel
        return vc
    }
}
