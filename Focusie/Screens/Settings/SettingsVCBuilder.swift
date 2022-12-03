//
//  SettingsVCBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVCBuilder {
    static func make(delegate:HomeVC ,viewModel: SettingsViewModelProtocol) -> UINavigationController {
        let vc = SettingsVC()
        
        vc.delegate = delegate
        vc.viewModel = viewModel
        
        let nav = UINavigationController(rootViewController: vc)
        
        let appereance = UINavigationBarAppearance()
        appereance.configureWithTransparentBackground()
        nav.navigationBar.standardAppearance = appereance
        nav.navigationBar.scrollEdgeAppearance = appereance
        
        return nav
    }
}
