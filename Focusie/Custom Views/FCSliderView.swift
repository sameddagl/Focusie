//
//  FCSliderView.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class FCSliderView: UIView {
    private let titleLabel = FCTitleLabel()
    private var valueLabel: UILabel!
    private var slider: UISlider!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, valueLabel: UILabel, slider: UISlider) {
        self.init(frame: .zero)
        titleLabel.text = title
        self.valueLabel = valueLabel
        self.slider = slider
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let titlesStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        titlesStack.distribution = .equalSpacing
        
        let mainStack = UIStackView(arrangedSubviews: [titlesStack, slider])
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 10
        
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.pinToEdges(of: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
