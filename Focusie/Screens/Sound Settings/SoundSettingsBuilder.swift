//
//  SoundSettingsBuilder.swift
//  Focusie
//
//  Created by Samed Dağlı on 7.12.2022.
//

import UIKit

final class SoundSettingsBuilder {
    static func make() -> UINavigationController{
        let vc = SoundSettingsVC()
        
        let viewModel = SoundSettingsViewModel()
        viewModel.delegate = vc
        vc.viewModel = viewModel
        
        return UINavigationController(rootViewController: vc)
    }
}
