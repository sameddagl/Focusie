//
//  AppRouter.swift
//  Focusie
//
//  Created by Samed Dağlı on 30.11.2022.
//

import UIKit

final class AppRouter {
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start(){
        let vc = HomeVCBuilder.make()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
