//
//  SettingsVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit

final class SettingsVC: UIViewController {
    private let focusTimeSlider = UISlider()
    private let focusTimeSliderLabel = FCTitleLabel(alignment: .left, fontSize: 15)
    
    private let breakTimeSlider = UISlider()
    private let breakTimeSliderLabel = FCTitleLabel(alignment: .left, fontSize: 15)
    
    var viewModel: SettingsViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    var delegate: SettingsUpdateDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutFocusTimeSettings()
        layoutBreakTimeSettings()
        
        viewModel.load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.updateTimes()
    }
    
    @objc private func focusTimeChanged() {
        viewModel.focusTimeChanged(sliderValue: focusTimeSlider.value)
    }
    
    @objc private func breakTimeChanged() {
        viewModel.breakTimeChanged(sliderValue: breakTimeSlider.value)
    }    
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }
}

extension SettingsVC: SettingsViewModelDelegate {
    func handleWithOutput(_ output: SettingsOutput) {
        switch output {
        case .updateInitialInfos(let infos):
            focusTimeSliderLabel.text = String(format: "%.0f", infos.focusTime)
            breakTimeSliderLabel.text = String(format: "%.0f", infos.breakTime)
            
            focusTimeSlider.setValue(infos.focusTime, animated: false)
            breakTimeSlider.setValue(infos.breakTime, animated: false)
            
            focusTimeSlider.isUserInteractionEnabled = infos.areSlidersEnabled
            breakTimeSlider.isUserInteractionEnabled = infos.areSlidersEnabled
        case .updateTimesOnMainScreen:
            delegate.didUpdateWithTimes()
        case .focusTimeChanged(let value):
            focusTimeSliderLabel.text = String(format: "%.0f", value)
            focusTimeSlider.setValue(value, animated: false)
        case .breakTimeChanged(let value):
            breakTimeSliderLabel.text = String(format: "%.0f", value)
            breakTimeSlider.setValue(value, animated: false)
        case .bgSoundChanged:
            break
        }
    }
}

//MARK: - UI Related
extension SettingsVC {
    private func configureView() {
        title = NSLocalizedString("settings_title", comment: "")
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    private func layoutFocusTimeSettings() {
        focusTimeSlider.minimumValue = 5
        focusTimeSlider.maximumValue = 35
        focusTimeSlider.tintColor = .systemPink
        
        focusTimeSlider.addTarget(self, action: #selector(focusTimeChanged), for: .valueChanged)
        
        let focusTimeSliderView = FCSliderView(title: NSLocalizedString("focus_time", comment: ""), valueLabel: focusTimeSliderLabel, slider: focusTimeSlider)
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
        
        breakTimeSlider.addTarget(self, action: #selector(breakTimeChanged), for: .valueChanged)
        
        let breakTimeSliderView = FCSliderView(title: NSLocalizedString("short_break", comment: ""), valueLabel: breakTimeSliderLabel, slider: breakTimeSlider)
        view.addSubview(breakTimeSliderView)
        
        NSLayoutConstraint.activate([
            breakTimeSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            breakTimeSliderView.topAnchor.constraint(equalTo: focusTimeSlider.bottomAnchor, constant: 40),
            breakTimeSliderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
}

