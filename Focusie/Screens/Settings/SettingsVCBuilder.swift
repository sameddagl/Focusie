//
//  SettingsVCBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVCBuilder {
    func make() -> UINavigationController {
        let vc = SettingsVC()
        vc.viewModel = SettingsViewModel()
        
        let nav = UINavigationController(rootViewController: vc)
        
        let appereance = UINavigationBarAppearance()
        appereance.configureWithTransparentBackground()
        nav.navigationBar.standardAppearance = appereance
        nav.navigationBar.scrollEdgeAppearance = appereance
        
        return nav
    }
}
