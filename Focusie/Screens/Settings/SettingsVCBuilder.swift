//
//  SettingsVCBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVCBuilder {
    static func make(rootView: HomeVC) -> UINavigationController {
        let vc = SettingsVC()
        
        let viewModel = SettingsViewModel()
        vc.viewModel = viewModel
        viewModel.delegate = vc
        viewModel.updateDelegate = rootView
        
        let nav = UINavigationController(rootViewController: vc)
        
        let appereance = UINavigationBarAppearance()
        appereance.configureWithTransparentBackground()
        nav.navigationBar.standardAppearance = appereance
        nav.navigationBar.scrollEdgeAppearance = appereance
        
        return nav
    }
}
