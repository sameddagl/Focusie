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
        let viewModel = HomeViewModel()
        
        vc.viewModel = viewModel
        viewModel.delegate = vc
        
        return vc
    }
}
