//
//  BGSound.swift
//  Focusie
//
//  Created by Samed Dağlı on 12.12.2022.
//

import Foundation

struct BGSound {
    let title: String
    var isSelected: Bool
    
    var sound: BGSounds {
        switch title {
        case "silent".localized():
            return .none
        case "piano".localized():
            return .piano
        case "forest".localized():
            return .forest
        case "cafe".localized():
            return .cafe
        case "rain".localized():
            return .rain
        case "music_box".localized():
            return .musicBox
        default:
            return .none
        }
    }
}
