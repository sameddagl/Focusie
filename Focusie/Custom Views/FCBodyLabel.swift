//
//  FCBodyLabel.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class FCBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(alignment: NSTextAlignment) {
        self.init(frame: .zero)
        textAlignment = alignment
    }

    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        font = .preferredFont(forTextStyle: .body)
        
        textColor = .label
        
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
