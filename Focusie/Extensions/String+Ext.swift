//
//  String+Ext.swift
//  Focusie
//
//  Created by Samed Dağlı on 18.12.2022.
//

import Foundation

extension String {
    func localized(with message: String = "") -> String{
        return NSLocalizedString(self, comment: message)
    }
}
