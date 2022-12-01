//
//  FCStateView.swift
//  Focusie
//
//  Created by Samed Dağlı on 30.11.2022.
//

import UIKit

final class FCStateView: UIView {
    let stateImage = UIImageView()
    let stateLabel = FCTitleLabel(alignment: .center, fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        stateLabel.text = text
    }
    
    func set(with state: States) {
        stateLabel.text = state.rawValue

        switch state {
        case .focus:
            stateImage.image = UIImage(named: "Focus")?.withRenderingMode(.alwaysTemplate)
        case .shortBreak:
            stateImage.image =  UIImage(named: "Break")?.withRenderingMode(.alwaysTemplate)
        case .longBreak:
            stateImage.image =  UIImage(named: "Break")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 20
        backgroundColor = .systemGreen
        
        let stack = UIStackView(arrangedSubviews: [stateImage, stateLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.spacing = 8
        addSubview(stack)
                
        stateLabel.textColor = .label
        
        stateImage.tintColor = .label
        stateImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            stateImage.widthAnchor.constraint(equalToConstant: 20),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


