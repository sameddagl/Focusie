//
//  FCTitleLabel.swift
//  Focusie
//
//  Created by Samed Dağlı on 30.11.2022.
//

import UIKit

final class FCTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = .label
        font = .systemFont(ofSize: 15, weight: .heavy)
        numberOfLines = 1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
