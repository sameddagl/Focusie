//
//  SoundSettingsBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 7.12.2022.
//

import UIKit

final class SoundSettingsBuilder {
    static func make(rootVC: HomeVC) -> UINavigationController{
        let vc = SoundSettingsVC()
        
        let viewModel = SoundSettingsViewModel(persistanceManager: app.persistanceManager)
        viewModel.delegate = vc
        vc.viewModel = viewModel
        vc.delegate = rootVC
        
        return UINavigationController(rootViewController: vc)
    }
}
