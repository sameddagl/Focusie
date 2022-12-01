//
//  SettingsVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVC: UIViewController {
    private let focusTimeSlider = UISlider()
    private let focusTimeSliderLabel = FCTitleLabel(text: "25")
    
    private let breakTimeSlider = UISlider()
    private let breakTimeSliderLabel = FCTitleLabel(text: "5")
    
    var viewModel: SettingsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutFocusTimeSettings()
        layoutBreakTimeSettings()
        
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        if sender == focusTimeSlider {
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            
            focusTimeSliderLabel.text = String(format: "%.0f", roundedValue)
            sender.value = roundedValue
        }
        else {
            let step: Float = 1
            let roundedValue = round(sender.value / step) * step
            
            breakTimeSliderLabel.text = String(format: "%.0f", roundedValue)
            sender.value = roundedValue
        }

    }
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }
}

extension SettingsVC: SettingsViewModelDelegate {
    func handleWithOutput(_ output: SettingsOutput) {
        switch output {
        case .updateInitialInfos(let times):
            break
        case .focusTimeChanged:
            break
        case .breakTimeChanged:
            break
        case .bgSoundChanged:
            break
        }
        
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

        focusTimeSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        
        let focusTimeSliderView = FCSliderView(title: "Settings", valueLabel: focusTimeSliderLabel, slider: focusTimeSlider)
        view.addSubview(focusTimeSliderView)
        
        NSLayoutConstraint.activate([
            focusTimeSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusTimeSliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            focusTimeSliderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func layoutBreakTimeSettings() {
        breakTimeSlider.minimumValue = 2
        breakTimeSlider.maximumValue = 7
        breakTimeSlider.tintColor = .systemPink
        breakTimeSlider.setValue(5, animated: false)

        breakTimeSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        
        let breakTimeSliderView = FCSliderView(title: "Short Break Time", valueLabel: breakTimeSliderLabel, slider: breakTimeSlider)
        view.addSubview(breakTimeSliderView)
        
        NSLayoutConstraint.activate([
            breakTimeSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            breakTimeSliderView.topAnchor.constraint(equalTo: focusTimeSlider.bottomAnchor, constant: 40),
            breakTimeSliderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
}

