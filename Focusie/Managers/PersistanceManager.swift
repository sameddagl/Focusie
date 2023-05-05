//
//  PersistanceManager.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation

enum Keys: String {
    case focusTime = "focusTime"
    case shortBreakTime = "shortBreakTime"
    case longBreakTime = "longBreakTime"
    case bgSound = "bgSound"
}

protocol PersistanceManagerProtocol {
    func retrieveData(forKey: Keys) -> Double?
    func save(focusTime: Double, shortBreakTime: Double, longBreakTime: Double)
    func retrieveBGSound() -> String?
    func saveBGSound(bgSound: BGSound)
}

final class PersistanceManager: PersistanceManagerProtocol {
    private let defaults = UserDefaults.standard
    
    func retrieveData(forKey: Keys) -> Double? {
        guard let value = defaults.value(forKey: forKey.rawValue) as? Double else { return nil}
        return value
    }
    
    func save(focusTime: Double, shortBreakTime: Double, longBreakTime: Double) {
        defaults.set(focusTime, forKey: Keys.focusTime.rawValue)
        defaults.set(shortBreakTime, forKey: Keys.shortBreakTime.rawValue)
        defaults.set(longBreakTime, forKey: Keys.longBreakTime.rawValue)
    }
    
    func retrieveBGSound() -> String? {
        guard let value = defaults.value(forKey: Keys.bgSound.rawValue) as? String else { return nil }
        return value
    }
    
    func saveBGSound(bgSound: BGSound) {
        defaults.set(bgSound.sound.rawValue, forKey: Keys.bgSound.rawValue)
    }
}
