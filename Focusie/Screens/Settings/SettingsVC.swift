//
//  SettingsVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVC: UIViewController {
    private let focusTimeSlider = UISlider()
    private let focusTimeValueLabel = FCTitleLabel(text: "25")
    
    private let breakTimeSlider = UISlider()
    
    var viewModel: SettingsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutFocusTimeSettings()
        
    }
    
    @objc private func focusTimeSliderChange() {
        let step: Float = 5
        let roundedValue = round(focusTimeSlider.value / step) * step
        focusTimeValueLabel.text = String(format: "%.0f", roundedValue)
        focusTimeSlider.value = roundedValue
    }
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }
}

extension SettingsVC: SettingsViewModelDelegate {
    func handleWithOutput(_ output: SettingsOutput) {
        
    }
}

//MARK: - UI Related
extension SettingsVC {
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    private func layoutFocusTimeSettings() {
        focusTimeSlider.minimumValue = 5
        focusTimeSlider.maximumValue = 35
        focusTimeSlider.tintColor = .systemPink
        focusTimeSlider.setValue(25, animated: false)

        focusTimeSlider.addTarget(self, action: #selector(focusTimeSliderChange), for: .valueChanged)
        
        let focusTimeSliderView = FCSliderView(title: "Settings", valueLabel: focusTimeValueLabel, slider: focusTimeSlider)
        view.addSubview(focusTimeSliderView)
        
        NSLayoutConstraint.activate([
            focusTimeSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusTimeSliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            focusTimeSliderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
}

