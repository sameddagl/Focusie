//
//  FCActionButton.swift
//  Focusie
//
//  Created by Samed Dağlı on 30.11.2022.
//

import UIKit

final class FCActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        
        backgroundColor = .systemGreen
        tintColor = .label
        
        setImage(UIImage(systemName: "play.fill"), for: .normal)
        setImage(UIImage(systemName: "pause.fill"), for: .selected)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
