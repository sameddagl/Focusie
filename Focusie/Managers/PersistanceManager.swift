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

}

final class PersistanceManager {
    private let defaults = UserDefaults.standard
    
    func retrieveData(forKey: Keys) -> Double? {
        guard let value = defaults.value(forKey: forKey.rawValue) as? Double else { return nil}
        return value
    }
    
    func save(focusTime: Double, shortBreakTime: Double) {
        defaults.set(focusTime, forKey: Keys.focusTime.rawValue)
        defaults.set(shortBreakTime, forKey: Keys.shortBreakTime.rawValue)
    }
}
