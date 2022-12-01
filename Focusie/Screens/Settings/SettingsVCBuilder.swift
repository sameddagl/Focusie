//
//  SettingsVCBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVCBuilder {
    static func make(rootVC: HomeVC, viewModel: SettingsViewModelProtocol) -> UINavigationController {
        let vc = SettingsVC()
        
        var viewModel = viewModel
        vc.viewModel = viewModel
        viewModel.updateDelegate = rootVC
        
        let nav = UINavigationController(rootViewController: vc)
        
        let appereance = UINavigationBarAppearance()
        appereance.configureWithTransparentBackground()
        nav.navigationBar.standardAppearance = appereance
        nav.navigationBar.scrollEdgeAppearance = appereance
        
        return nav
    }
}
