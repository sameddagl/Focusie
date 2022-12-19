//
//  SettingsVCBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVCBuilder {
    static func make(delegate:HomeVC ,canChangeValues: Bool) -> UINavigationController {
        let vc = SettingsVC()
        let viewModel = SettingsViewModel(persistanceManager: app.persistanceManager, canChangeValues: canChangeValues)
        
        vc.delegate = delegate
        vc.viewModel = viewModel
        viewModel.delegate = vc
        
        let nav = UINavigationController(rootViewController: vc)
        
        let appereance = UINavigationBarAppearance()
        appereance.configureWithTransparentBackground()
        nav.navigationBar.standardAppearance = appereance
        nav.navigationBar.scrollEdgeAppearance = appereance
        
        return nav
    }
}
