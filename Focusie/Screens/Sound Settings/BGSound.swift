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
        case "None":
            return .none
        case "Piano":
            return .piano
        case "Forest":
            return .forest
        case "Cafe":
            return .cafe
        default:
            return .none
        }
    }
}
