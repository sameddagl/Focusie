//
//  AppContainer.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation

let app = AppContainer()

final class AppContainer {
    
    let audioManager = AudioManager()
    let persistanceManager = PersistanceManager()
    let notificationManager = LocalNotificationManager()
}
